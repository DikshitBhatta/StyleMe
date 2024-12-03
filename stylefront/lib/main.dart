import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/pages/home.dart';
import 'package:stylefront/provider/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cartProvider = CartProvider();
  await cartProvider.loadCart();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => cartProvider),
      ],
      child: const MyApp(),
    ),
  );
}

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