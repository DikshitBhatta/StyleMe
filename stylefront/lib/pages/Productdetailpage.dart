import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:stylefront/methods/opencart.dart';
import 'package:stylefront/widgets/Rating.dart';
import 'package:stylefront/widgets/recommended.dart';
import 'package:stylefront/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/favorite_provider.dart';
import 'package:stylefront/pages/buypage.dart';
import 'package:stylefront/utility/csv.dart';
import 'package:html/parser.dart' as html_parser; 
import 'package:stylefront/widgets/justforyou.dart';
import 'package:stylefront/pages/shop.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? productData;
  List<String> productImages = [];

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
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

  String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
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
    final sizes = ['S', 'M', 'L', 'XL'];
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite = favoriteProvider.isFavorite(widget.productId);

    if (productData == null) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final String imageUrl = 'assets/images/${widget.productId}.jpg';
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
                      'id': widget.productId,
                      'name': productData?['productDisplayName'],
                      'price': productData?['price'],
                      'image': 'assets/images/${widget.productId}.jpg',
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
            Text(
              'NRP ${productData?['price']}',
              style: const TextStyle(fontSize: 20, color: Color(0xFFFF4B9E)),
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
                children: const [
                  Icon(Icons.star, color: Colors.yellow),
                  SizedBox(width: 4.0),
                  Text('Rating'),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        height: 25.0,
                        width: 25.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Text(size)),
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
                          'id': widget.productId,
                          'name': productData?['productDisplayName'],
                          'price': productData?['price'],
                          'image': 'assets/images/${widget.productId}.jpg',
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
                          'name': productData?['productDisplayName'],
                          'price': productData?['price'],
                          'image': 'assets/images/${widget.productId}.jpg',
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
                Rating(),

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
