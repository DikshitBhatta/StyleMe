
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/order_provider.dart';

class PaymentSuccessfulPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const PaymentSuccessfulPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Add the product to orders when payment is successful
    orderProvider.addOrder(product);

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
}