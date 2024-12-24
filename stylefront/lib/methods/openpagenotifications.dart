import 'package:flutter/material.dart';
import 'package:stylefront/pages/notifications.dart';

void openpagenotifications(BuildContext context, {bool fullscreenDialog = false}){
  Navigator.push(context,
  MaterialPageRoute(
    fullscreenDialog: fullscreenDialog,
    builder:(context) => NotificationScreen(),
  ));
}