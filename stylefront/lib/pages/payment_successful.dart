import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:stylefront/pages/Productdetailpage.dart';
import 'package:stylefront/provider/order_provider.dart';
import 'package:stylefront/provider/notification_provider.dart';

class PaymentSuccessfulPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool addOrderAndNotification;

  const PaymentSuccessfulPage({super.key, required this.product, this.addOrderAndNotification = true});

  @override
  Widget build(BuildContext context) {
    if (addOrderAndNotification) {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

      if (!orderProvider.orders.any((order) => order['productId'] == product['productId'])) {
        orderProvider.addOrder(product);
        _saveOrders(orderProvider);

        Future.delayed(Duration(seconds: 1), () {
          final message = 'Your order has been placed successfully!';
          final imagePath = product['image'];
          if (message.isNotEmpty && imagePath.isNotEmpty) {
            notificationProvider.addNotification(message, imagePath);
            print('Notification added in PaymentSuccessfulPage: $message'); // Debug print
            print('Image path: $imagePath'); // Debug print
          } else {
            print('Error: message or imagePath is empty'); // Debug print
          }
        });
      }
    }

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
                final productId = product['productId'];
                if (productId is String) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(productId: int.tryParse(productId)), // Convert to int
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else if (productId is int) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(productId: productId),
                    ),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  print('Error: product id is not valid');
                }
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
}