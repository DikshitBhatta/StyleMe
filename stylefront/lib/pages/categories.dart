import 'package:flutter/material.dart';
import 'package:stylefront/pages/Productdetailpage.dart';
import 'package:stylefront/utility/csv.dart';

class CategoriesPage extends StatelessWidget {
  final String category;

  CategoriesPage({required this.category});

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    final products = await DataParser.loadcsv('assets/fashion_sample_5k.csv');
    return products.where((product) => product['articleType'] == category || product['usage'] == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items to display'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(productId: int.parse(product['id'])),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/${product['id']}.jpg',
                            fit: BoxFit.fill,
                            height: double.infinity,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['productDisplayName'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                product['brandName'],
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Rs.${product['price']}',
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
