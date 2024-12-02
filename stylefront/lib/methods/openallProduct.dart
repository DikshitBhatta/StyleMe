import 'package:flutter/material.dart';
import 'package:stylefront/pages/product.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/utility/csv.dart';


void openallProduct(BuildContext context, {bool fullscreenDialog = false}) async{
   WidgetsFlutterBinding.ensureInitialized();

  // Load the CSV data
  List<Map<String, dynamic>> rawCsvData = await DataParser.loadcsv('assets/fashion_sample_5k.csv');
  List<Map<String, dynamic>> jsonData = await DataParser.loadStyles('assets/merged_data.json');


  // Convert all values to String explicitly
  List<Map<String, String>> normalizedData = rawCsvData.map((row) {
    return row.map((key, value) => MapEntry(key, value.toString()));
  }).toList();

  // Map normalized data to Product objects
  List<Product> products = normalizedData.map((map) {
    print("Mapping Data: $map"); // Debug log to see the data for each product
    return Product.fromMap(map);
  }).toList();

  Navigator.push(context,
  MaterialPageRoute(
    fullscreenDialog: fullscreenDialog,
    builder:(context) => ProductCatalogue(products: products),
  ));
}