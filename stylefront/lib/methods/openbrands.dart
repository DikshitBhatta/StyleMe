import 'package:flutter/material.dart';
import 'package:stylefront/pages/brandpage.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/methods/productfromcsv.dart';

void openBrands(BuildContext context, String brand, {bool fullscreenDialog = false}) async {
  List<Product> products = await productfromcsv();
  Navigator.push(context,
    MaterialPageRoute(
      fullscreenDialog: fullscreenDialog,
      builder: (context) => brandPage(products: products, brand: brand),
    ),
  );
}