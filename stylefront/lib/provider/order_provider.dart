import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => _orders;

  void addOrder(Map<String, dynamic> order) {
    _orders.add(order);
    _saveOrders();
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    _saveOrders();
    notifyListeners();
  }

  void loadOrders(List<String> orders) {
    _orders = orders.map((order) => Map<String, dynamic>.from(jsonDecode(order))).toList();
    notifyListeners();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final orders = _orders.map((order) => jsonEncode(order)).toList();
    prefs.setStringList('orders', orders);
  }
}
