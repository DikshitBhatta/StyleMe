import 'package:flutter/material.dart';
import 'package:stylefront/methods/openbrands.dart';
import 'package:stylefront/pages/product.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/utility/csv.dart';
import 'package:stylefront/methods/productfromcsv.dart';


class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productfromcsv(),
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
              .take(100)
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
                SizedBox(
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
                            openBrands(context, brandNames[index]);
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
