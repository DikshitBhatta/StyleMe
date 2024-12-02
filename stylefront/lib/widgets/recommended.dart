import 'package:flutter/material.dart';
import 'package:stylefront/pages/product.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/utility/csv.dart';

Future<List<Product>> recommended() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Map<String, dynamic>> rawCsvData = await DataParser.loadcsv('assets/fashion_sample_5k.csv');
  List<Map<String, String>> normalizedData = rawCsvData.map((row) {
    return row.map((key, value) => MapEntry(key, value.toString()));
  }).toList();
  List<Product> products = normalizedData.map((map) {
    print("Mapping Data: $map"); 
    return Product.fromMap(map);
  }).toList();

  return products;
}

class RecommendedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      
      future: recommended(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No products found"));
        } else {
          final products = snapshot.data!.take(5).toList(); 
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Text('RECOMMENDED',
            style: TextStyle(fontSize: 30.0),),
            GridView.builder(
              shrinkWrap: true, 
              physics: NeverScrollableScrollPhysics(), 
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
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
              ],
            ),
          );
        }
      },
    );
  }
}
