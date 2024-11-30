import 'package:flutter/material.dart';

class Notifications extends StatefulWidget{
  const Notifications ({super.key});
  @override
  _NotificationsState createState()=> _NotificationsState();
}

class _NotificationsState extends State<Notifications>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Notifications',),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){},
        ),
      ],),
      body: Center(
        child: Text('Notifications'),
      ),
    );
  }
}