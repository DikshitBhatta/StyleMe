import 'package:flutter/material.dart';
import 'package:stylefront/pages/favorites.dart';
import 'package:stylefront/utility/csv.dart';
import 'package:stylefront/models/datamodels.dart';

class ProductCatalogue extends StatelessWidget {
  final List<Product> products;
  const ProductCatalogue({Key? key, required this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Catalogue'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {}, 
          ),
          IconButton(
            icon: Icon(Icons.favorite,color: Colors.red,),
            onPressed: () {}, 
          ),
          
        ],
      ),
      body: Padding(
  padding: const EdgeInsets.all(8.0),
  child: products.isEmpty
    ? Center(child: Text("No products found"))
    : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  
                  child:Image.asset(
                    'assets/images/${product.id}.jpg',
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                  ),),
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
          );
        },
      ),
),


    );
  }
}
