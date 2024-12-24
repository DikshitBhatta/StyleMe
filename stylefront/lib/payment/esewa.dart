import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/constants/esewaconstants.dart';
import 'package:stylefront/provider/order_provider.dart';
import 'package:stylefront/provider/notification_provider.dart';
import 'package:stylefront/pages/payment_successful.dart';
import 'package:http/http.dart' as http;

class Esewa {
  final Map<String, dynamic> product;

  Esewa({required this.product});

  Future<bool> initiatePayment(String productName, String productPrice, BuildContext context) async {
    Completer<bool> paymentResult= Completer();
    try {
    EsewaFlutterSdk.initPayment(
      esewaConfig: EsewaConfig(
        environment: Environment.test,
        clientId: keSewaClientId,
        secretId: keSewaSecretKey,
      ),
      esewaPayment: EsewaPayment(
        productId: "1d71jd81",
        productName: productName,
        productPrice: productPrice,
        callbackUrl: "https://example.com/callback",
      ),
      onPaymentSuccess: (EsewaPaymentSuccessResult data) {
        debugPrint(":::SUCCESS::: => $data");
        debugPrint("Transaction Reference ID: ${data.refId}");

        // Save order details if not already added
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        if (!orderProvider.orders.contains(product)) {
          orderProvider.addOrder(product);
        }

        // Add notification
        final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        final message = 'Your order has been placed successfully!';
        final imagePath = product['image'];
        if (message.isNotEmpty && imagePath.isNotEmpty) {
          notificationProvider.addNotification(message, imagePath);
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Successful!')),
        );

        // Navigate to PaymentSuccessfulPage without adding order and notification again
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessfulPage(product: product, addOrderAndNotification: false),
          ),
        );

        paymentResult.complete(true); // Complete with success
      },
      onPaymentFailure: (data) {
        debugPrint(":::FAILURE::: => $data");
        paymentResult.complete(false); // Complete with failure
      },
      onPaymentCancellation: (data) {
        debugPrint(":::CANCELLATION::: => $data");
        paymentResult.complete(false); // Complete with cancellation
      },
    );
  } on Exception catch (e) {
    debugPrint("EXCEPTION : ${e.toString()}");
    paymentResult.complete(false); // Complete with failure on exception
  }

  return paymentResult.future; // Wait for the result
}

  void verifyPayment(String refId, BuildContext context) async {
    final String basicAuth = 'Basic ${base64.encode(utf8.encode('YOUR_CLIENT_ID:YOUR_SECRET_KEY'))}';
    final String url = 'https://esewa.com.np/mobile/transaction';

    try {
      // Making the GET request
      final response = await http.get(
        Uri.parse('$url?txnRefId=$refId'),
        headers: {
          'Authorization': basicAuth,
        },
      );

      // Checking the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Response Data: $data');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Verified!')),
        );
      } else {
        debugPrint('Failed to verify payment: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Verification Failed!')),
        );
      }
    } catch (e) {
      debugPrint('Error during verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during payment verification!')),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }
}