import 'package:flutter/material.dart';
import 'package:stylefront/pages/favorites.dart';

void openpagefavorite(BuildContext context, {bool fullscreenDialog = false}){
  Navigator.push(context,
  MaterialPageRoute(
    fullscreenDialog: fullscreenDialog,
    builder:(context) => Favorites(),
  ));
}