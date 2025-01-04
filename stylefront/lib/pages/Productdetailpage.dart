import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:stylefront/methods/opencart.dart';
import 'package:stylefront/widgets/Rating.dart';
import 'package:stylefront/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/favorite_provider.dart';
import 'package:stylefront/pages/buypage.dart';
import 'package:stylefront/utility/csv.dart';
import 'package:html/parser.dart' as html_parser; 
import 'package:stylefront/widgets/justforyou.dart';
import 'package:stylefront/pages/searchpage.dart';
import 'package:stylefront/pages/tryon.dart';
import '../providers/recommended_size_provider.dart';
import 'package:stylefront/methods/review.dart';
import 'package:stylefront/models/review.dart';

class ProductDetailPage extends StatefulWidget {
  final int? productId;

  const ProductDetailPage({super.key, this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? productData;
  List<String> productImages = [];
  final ImagePicker _picker = ImagePicker();
  String? selectedSize;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
    selectedSize = Provider.of<RecommendedSizeProvider>(context, listen: false).recommendedSize;
    _loadReviews();
  }

  Future<void> _loadProductDetails() async {
    if (widget.productId == null) {
      debugPrint('Error: productId is null');
      return;
    }

    try {
      final String response = await rootBundle.loadString('assets/styles/${widget.productId}.json');
      final Map<String, dynamic> data = jsonDecode(response);
      if (mounted) {
        setState(() {
          productData = data['data'];
          productImages = DataParser.parseImageUrls(data['data']);
          debugPrint('Product Images: $productImages');
        });
      }
    } catch (e) {
      debugPrint('Error loading product details: $e');
    }
  }

  Future<void> _loadReviews() async {
    if (widget.productId == null) {
      debugPrint('Error: productId is null');
      return;
    }

    getReviews(widget.productId.toString()).listen((List<Review> reviews) {
      if (mounted) {
        setState(() {
          averageRating = _calculateAverageRating(reviews);
        });
      }
    });
  }

  double _calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) return 0.0;
    double sum = reviews.fold(0, (previousValue, review) => previousValue + review.rating);
    return sum / reviews.length;
  }

  String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  void _onSearchSubmitted(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(query: query),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final String imageUrl = 'assets/images/${widget.productId ?? 'default'}.jpg';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TryOnPage(imagePath: pickedFile.path, productImageUrl: imageUrl),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                onSubmitted: _onSearchSubmitted,
              ),
            ),
            Icon(Icons.mic, color: Colors.black),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: ()=>openCart(context), icon: Icon(Icons.shopping_bag)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizes = ['S', 'M', 'L', 'XL', '2X', '3X', '4X', '5X'];
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite = favoriteProvider.isFavorite(widget.productId ?? 0);

    if (productData == null) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final String imageUrl = 'assets/images/${widget.productId ?? 'default'}.jpg';

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              if (productImages.isNotEmpty)
                SizedBox(
                  height: 300.00,
                  child: PageView.builder(
                    itemCount: productImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        productImages[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Error loading image: $error');
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.broken_image,
                                size: 100,
                              ),
                              SizedBox(height: 8),
                              Text('Failed to load image'),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              else
                const Center(
                  child: Text('No images available'),
                ),
              Positioned(
                top: 5.00,
                right: 5.00,
                child: IconButton(
                  onPressed: () {
                    favoriteProvider.toggleFavorite({
                      'id': widget.productId ?? 0,
                      'name': productData?['productDisplayName'],
                      'price': productData?['price'],
                      'image': 'assets/images/${widget.productId ?? 'default'}.jpg',
                    });
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                    color: isFavorite ? Colors.red : null,
                    size: 30.0,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16.0),
            Text(
              productData?['productDisplayName'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${productData?['brandName']}',
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NRP ${productData?['price']}',
                  style: const TextStyle(fontSize: 20, color: Color(0xFFFF4B9E)),
                ),
                ElevatedButton(
                  onPressed: _showImageSourceDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Try On', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            if (productData?['price'] != productData?['discountedPrice'])
              Text(
                'Discounted Price: ₹${productData?['discountedPrice']}',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(averageRating.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w800)), // Display the average rating
                  const Icon(Icons.star, color: Colors.yellow),
                  const SizedBox(width: 4.0),
                  const Text('Rating'),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Size Guide'),
                Row(
                  children: sizes.map((size) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: BoxDecoration(
                            color: selectedSize == size ? Colors.blue : Colors.white,
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text(size)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        final product = {
                          'id': widget.productId ?? 0,
                          'name': productData?['productDisplayName'],
                          'price': productData?['price'],
                          'image': 'assets/images/${widget.productId ?? 'default'}.jpg',
                        };
                        Provider.of<CartProvider>(context, listen: false).addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product added to cart!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFE6016),
                        minimumSize: Size(150.00, 40.00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                        ),
                      ),
                      child: Text(
                        'Add To Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final selectedProduct = {
                          'productId': widget.productId ?? 0,
                          'name': productData?['productDisplayName'],
                          'price': productData?['price'],
                          'image': 'assets/images/${widget.productId ?? 'default'}.jpg',
                          'quantity': 1,
                        };
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              selectedItems: [selectedProduct],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF73D83C),
                        minimumSize: Size(150.00, 40.00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.elliptical(10.0, 10.0)),
                        ),
                      ),
                      child: Text(
                        'Buy now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Rating(productId: widget.productId.toString()), // Fix the Rating widget instantiation

                const SizedBox(height: 16.0),
                if (productData?['productDescriptors']?['description']?['value'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _parseHtmlString(productData!['productDescriptors']['description']['value']),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                const SizedBox(height: 16.0),
                buildJustForYouSection(
                  productData: productData,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
