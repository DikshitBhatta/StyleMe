import 'package:flutter/material.dart';

class RecommendedSizeProvider with ChangeNotifier {
  String? _recommendedSize;

  String? get recommendedSize => _recommendedSize;

  void setRecommendedSize(String size) {
    _recommendedSize = size;
    notifyListeners();
  }
}
