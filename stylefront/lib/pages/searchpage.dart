import 'package:flutter/material.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/methods/productfromcsv.dart';
import 'package:stylefront/pages/Productdetailpage.dart';

class SearchPage extends StatefulWidget {
  final String query;

  const SearchPage({super.key, required this.query});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Product>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = _performSearch(widget.query);
  }

  Future<List<Product>> _performSearch(String query) async {
    final products = await productfromcsv();
    return products.where((product) {
      final nameLower = product.productDisplayName.toLowerCase();
      final categoryLower = product.subCategory.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower) || categoryLower.contains(queryLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.query}'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products found"));
          } else {
            final products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
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
                          builder: (context) => ProductDetailPage(productId: int.parse(product.id)),
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
                              'assets/images/${product.id}.jpg',
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
                                  product.productDisplayName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  product.brandName,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'Rs.${product.price}',
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
              ),
            );
          }
        },
      ),
    );
  }
}
