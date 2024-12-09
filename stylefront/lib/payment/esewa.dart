import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/constants/esewaconstants.dart';
import 'package:stylefront/provider/order_provider.dart';

class Esewa {
  final Map<String, dynamic> product;

  Esewa({required this.product});

  void initiatePayment(String productName, String productPrice, BuildContext context) {
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
          Provider.of<OrderProvider>(context, listen: false).addOrder(product);
          verify(data, context);
        },
        onPaymentFailure: (data) {
          debugPrint(":::FAILURE::: => $data");
        },
        onPaymentCancellation: (data) {
          debugPrint(":::CANCELLATION::: => $data");
        },
      );
    } on Exception catch (e) {
      debugPrint("EXCEPTION : ${e.toString()}");
    }
  }

  void verify(EsewaPaymentSuccessResult result, BuildContext context) async {
    try {
      Dio dio = Dio();
      String basic =
          'Basic ${base64.encode(utf8.encode('JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R:BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ=='))}';
      Response response = await dio.get(
        'https://esewa.com.np/mobile/transaction',
        queryParameters: {
          'txnRefId': result.refId,
        },
        options: Options(
          headers: {
            'Authorization': basic,
          },
        ),
      );
      print('Response data: ${response.data}');
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Verified!')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Verification Failed!')),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }
}