import 'package:flutter/material.dart';
import 'package:stylefront/pages/product.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/utility/csv.dart';
import 'package:stylefront/pages/Productdetailpage.dart';

Future<List<Product>> productfromcsv() async {
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