import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/notification_provider.dart';
import 'package:stylefront/pages/myOrders.dart';

class NotificationManager with ChangeNotifier {
  final List<String> _notifications = [];

  List<String> get notifications => _notifications;

  void addNotification(String message) {
    _notifications.add(message);
    notifyListeners();
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

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false).clearNotifications();
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          print('Building NotificationScreen with notifications: ${notificationProvider.notifications}');
          return notificationProvider.notifications.isEmpty
              ? Center(
                  child: Text(
                    'No notifications yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: notificationProvider.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notificationProvider.notifications[index];
                    return ListTile(
                      leading: Image.asset(notification.imagePath, width: 50, height: 50, fit: BoxFit.fill),
                      title: Text(notification.message),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          notificationProvider.removeNotification(index);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrdersPage(),
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
