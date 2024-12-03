import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> get cartItem => _cartItems;

  CartProvider() {
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cartItems');
    if (cartData != null) {
      _cartItems = List<Map<String, dynamic>>.from(
        json.decode(cartData).map((item) => Map<String, dynamic>.from(item))
      );
      print('Cart loaded: $_cartItems'); // Debug statement
    } else {
      print('No cart data found'); // Debug statement
    }
    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cartItems', json.encode(_cartItems));
    print('Cart saved: $_cartItems'); // Debug statement
  }

  void addToCart(Map<String, dynamic> product) {
    final existingItemIndex = _cartItems.indexWhere((item) => item['id'] == product['id']);
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex]['quantity'] += 1;
    } else {
      _cartItems.add({...product, 'quantity': 1, 'isSelected': false});
    }
    print('Item added: $product'); // Debug statement
    saveCart(); // Save cart after modification
    notifyListeners();
  }

  void removeFromCart(int index) {
    print('Item removed: ${_cartItems[index]}'); // Debug statement
    _cartItems.removeAt(index);
    saveCart(); // Save cart after modification
    notifyListeners();
  }

  void toggleSelection(int index) {
    _cartItems[index]['isSelected'] = !_cartItems[index]['isSelected'];
    print('Item selection toggled: ${_cartItems[index]}'); // Debug statement
    saveCart(); // Save cart after modification
    notifyListeners();
  }

  List<Map<String, dynamic>> get selectedItems {
    return _cartItems.where((item) => item['isSelected']).toList();
  }

  void clearCart() {
    print('Cart cleared'); // Debug statement
    _cartItems.clear();
    saveCart(); // Save cart after modification
    notifyListeners();
  }
}