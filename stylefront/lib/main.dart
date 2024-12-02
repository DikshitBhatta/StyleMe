import 'package:flutter/material.dart';
import 'package:stylefront/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
return MaterialApp(
  debugShowCheckedModeBanner: false,
  title:'Stylefront',
  theme: ThemeData(
    primarySwatch: Colors.blue,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
          ),
  ),
  home: Home(),
    );
  }
}