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
static Future<List<Map<String, dynamic>>> loadStyles(String folderPath) async {
  try {
    // Load the AssetManifest to find all files in the styles folder
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter JSON files in the specified folder
    final styleFiles = manifestMap.keys
        .where((path) => path.startsWith(folderPath) && path.endsWith('.json'));

    // Load and parse each JSON file
    List<Map<String, dynamic>> allStyles = [];
    for (final file in styleFiles) {
      final jsonString = await rootBundle.loadString(file);
      allStyles.add(json.decode(jsonString));
    }

    return allStyles;
  } catch (e) {
    print("Error loading JSON styles: $e");
    return [];
  }
}
}
