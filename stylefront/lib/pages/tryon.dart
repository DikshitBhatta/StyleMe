import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TryOnPage extends StatefulWidget {
  final String imagePath;
  final String productImageUrl;

  const TryOnPage({super.key, required this.imagePath, required this.productImageUrl});

  @override
  _TryOnPageState createState() => _TryOnPageState();
}

class _TryOnPageState extends State<TryOnPage> {
  bool _isLoading = true;
  String? _processedImageUrl;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      final response = await http.post(
        Uri.parse('http://example.com/process-image'), // Replace with actual backend API
        body: {
          'image': File(widget.imagePath).readAsBytesSync(),
          'productImage': widget.productImageUrl,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _processedImageUrl = 'http://example.com/processed-image.jpg'; // Replace with actual URL from response
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to process image');
      }
    } catch (e) {
      print('Error processing image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Try On'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _processedImageUrl != null
                ? Image.network(_processedImageUrl!)
                : Text('Failed to process image'),
      ),
    );
  }
}
