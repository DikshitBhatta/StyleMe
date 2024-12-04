import 'package:flutter/material.dart';
import 'package:stylefront/pages/shop.dart';

void openCart(BuildContext context, {bool fullscreenDialog = false}){
  Navigator.push(context,
  MaterialPageRoute(
    fullscreenDialog: fullscreenDialog,
    builder:(context) => Cart(),
  ));
}