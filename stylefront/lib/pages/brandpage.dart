import 'package:flutter/material.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/pages/Productdetailpage.dart';

class brandPage extends StatelessWidget {
  final List<Product> products;
  final String brand;
  const brandPage({super.key, required this.products, required this.brand});

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) => product.brandName == brand).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(brand),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {}, 
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: filteredProducts.isEmpty
          ? Center(child: Text("No products found"))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(productId: int.parse(product.id)),
                      ),
                    );
                  },
                child:Card(
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
                ),);
              },
            ),
      ),
    );
  }
}
