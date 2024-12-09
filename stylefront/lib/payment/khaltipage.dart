import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/order_provider.dart';

class KhaltiPaymentWidget extends StatelessWidget {
  final double totalPrice;
  final Map<String, dynamic> product;

  const KhaltiPaymentWidget({Key? key, required this.totalPrice, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      payWithKhaltiInApp(context, totalPrice);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Khalti Payment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void payWithKhaltiInApp(BuildContext context, double totalPrice) {
    double totalPrice=10;
    final config = PaymentConfig(
      amount: (totalPrice * 100).toInt(), // in paisa
      productIdentity: 'product_id',
      productName: 'Product Name',
      productUrl: 'https://example.com/product',
      additionalData: {
        'vendor': 'Vendor Name',
        'remarks': 'Payment remarks',
      },
    );

    KhaltiScope.of(context).pay(
      config: config,
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: (successModel) {
        // Add the product to orders when payment is successful
        Provider.of<OrderProvider>(context, listen: false).addOrder(product);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Successful!')),
        );
        Navigator.of(context).pop();
      },
      onFailure: (failureModel) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Failed: ${failureModel.message}')),
        );
        Navigator.of(context).pop();
      },
      onCancel: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Cancelled')),
        );
        Navigator.of(context).pop();
      },
    );
  }
}
