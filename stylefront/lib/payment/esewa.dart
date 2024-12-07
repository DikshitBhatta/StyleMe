import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:stylefront/constants/esewaconstants.dart';

class Esewa {
  void initiatePayment(String productName, String productPrice) {
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
          verify(data);
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

 verify(EsewaPaymentSuccessResult result) async {
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
      print(response.data);
    } catch (e) {
      print(e);
    }
  }
}