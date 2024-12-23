import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/order_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaymentSuccessfulPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const PaymentSuccessfulPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    orderProvider.addOrder(product);
    _saveOrders(orderProvider); 
    Future.delayed(Duration(seconds: 1), () {
      print('Attempting to save notification...');
      _saveNotifications('Your order has been placed successfully!');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveOrders(OrderProvider orderProvider) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = orderProvider.orders.map((order) => jsonEncode(order)).toList();
    prefs.setStringList('orders', orders);
    print('Orders saved: $orders'); 
  }

  Future<void> _saveNotifications(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('notifications') ?? [];
    notifications.add(message);
    await prefs.setStringList('notifications', notifications);
    print('Notification saved: $message'); 
    print('All notifications: $notifications');
  }
}