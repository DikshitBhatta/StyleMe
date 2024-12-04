import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class DataParser{
 static Future<List<Map<String, dynamic>>> loadcsv(String path) async {
  try {
    final csvString = await rootBundle.loadString(path);
    print("CSV File Loaded Successfully");

    List<List<dynamic>> rows = const CsvToListConverter(
      eol: '\n',
    ).convert(csvString);

    if (rows.isEmpty) {
      print("No rows found in CSV");
      return [];
    }

    // Ensure the first row contains headers
    List<String> headers = rows.first.map((e) => e.toString()).toList();
    print("CSV Headers: $headers");

    // Map each row to a Product
    List<Map<String, dynamic>> data = rows
        .skip(1)
        .map((row) {
          Map<String, dynamic> rowData = {};
          for (int i = 0; i < row.length; i++) {
            rowData[headers[i]] = row[i];
          }
          return rowData;
        })
        .toList();

    print("Parsed Data: $data");
    return data;
  } catch (e) {
    print("Error loading CSV: $e");
    return [];
  }
}





  /// Load all JSON files in the folder
static Future<List<Map<String, dynamic>>> loadStyles(String path) async {
  try {
    // Load the merged_data.json file directly from the assets
    final jsonString = await rootBundle.loadString(path);

    // Decode the JSON string into a List of Maps (i.e., a List of product data)
    List<Map<String, dynamic>> jsonData = List<Map<String, dynamic>>.from(json.decode(jsonString));

    return jsonData;
  } catch (e) {
    print("Error loading JSON styles: $e");
    return [];
  }
}

  static List<String> parseImageUrls(Map<String, dynamic> jsonData) {
    List<String> imageUrls = [];
    if (jsonData.containsKey('styleImages')) {
      jsonData['styleImages'].forEach((key, value) {
        if (value is Map && value.containsKey('imageURL')) {
          imageUrls.add(value['imageURL']);
        }
      });
    }
    return imageUrls;
  }

}
