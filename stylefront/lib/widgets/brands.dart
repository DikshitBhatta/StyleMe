import 'package:flutter/material.dart';
import 'package:stylefront/pages/product.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/utility/csv.dart';

Future<List<Product>> brands() async {
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

class BrandsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: brands(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No brands found"));
        } else {
          final products = snapshot.data!;
          final brandNames = products
              .map((product) => product.brandName)
              .toSet()
              .take(10)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brands',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 40.00,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: brandNames.length,
                    itemBuilder: (context, index) {
                      final brandName = brandNames[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: Color(0xFF023C45),
                            side: BorderSide(color: Colors.black),
                          ),
                          onPressed: () {
                            print('Selected Brand: $brandName');
                          },
                          child: Text(
                            brandName,
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.white),
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
      },
    );
  }
}