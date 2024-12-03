import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _favoriteItems = [];

  List<Map<String, dynamic>> get favoriteItems => _favoriteItems;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = prefs.getString('favoriteItems');
    if (favoriteData != null) {
      _favoriteItems.clear();
      _favoriteItems.addAll(List<Map<String, dynamic>>.from(json.decode(favoriteData)));
      notifyListeners();
    }
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favoriteItems', json.encode(_favoriteItems));
  }

  void toggleFavorite(Map<String, dynamic> product) {
    final existingIndex = _favoriteItems.indexWhere((item) => item['id'] == product['id']);
    if (existingIndex >= 0) {
      _favoriteItems.removeAt(existingIndex);
    } else {
      _favoriteItems.add(product);
    }
    saveFavorites();
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favoriteItems.any((item) => item['id'] == productId);
  }
}
