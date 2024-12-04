import 'package:flutter/material.dart';
import 'package:stylefront/utility/csv.dart';
import 'package:stylefront/pages/Productdetailpage.dart';

class buildJustForYouSection extends StatefulWidget {
  final Map<String, dynamic>? productData;

  const buildJustForYouSection({
    Key? key,
    required this.productData,
  }) : super(key: key);

  @override
  _buildJustForYouSectionState createState() => _buildJustForYouSectionState();
}

class _buildJustForYouSectionState extends State<buildJustForYouSection> {
  List<Map<String, dynamic>> justForYouProducts = [];

  @override
  void initState() {
    super.initState();
    _loadJustForYouProducts();
  }

  Future<void> _loadJustForYouProducts() async {
    try {
      List<Map<String, dynamic>> allStyles = await DataParser.loadAllStyles();
      String? subCategory = widget.productData?['subCategory']?['typeName'];
      String? gender = widget.productData?['gender'];
      if (subCategory != null && gender != null && mounted) {
        setState(() {
          justForYouProducts = allStyles
              .where((style) => style['subCategory']?['typeName'] == subCategory && style['gender'] == gender)
              .take(10)
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading just for you products: $e');
    }
  }

  List<Widget> buildAttributes() {
    final attributes = widget.productData?['articleAttributes'];
    if (attributes == null) return [];

    return attributes.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text('${entry.key}: ${entry.value}'),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Just for You:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: justForYouProducts.length,
              itemBuilder: (context, index) {
                final product = justForYouProducts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(productId: product['id']),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/images/${product['id']}.jpg',
                                fit: BoxFit.contain,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 100),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['productDisplayName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    'NRP ${product['price']}',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

