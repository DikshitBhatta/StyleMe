import 'package:flutter/material.dart';

class Notification {
  final String message;
  final String imagePath;

  Notification({required this.message, required this.imagePath});
}

class NotificationProvider with ChangeNotifier {
  final List<Notification> _notifications = [];

  List<Notification> get notifications => _notifications;

  void addNotification(String message, String imagePath) {
    if (message.isNotEmpty && imagePath.isNotEmpty) {
      _notifications.add(Notification(message: message, imagePath: imagePath));
      print('Notification added: $message');
      print('Image path: $imagePath');
      print('Current notifications: $_notifications');
      notifyListeners();
    } else {
      print('Error: message or imagePath is empty');
    }
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void removeNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }
}