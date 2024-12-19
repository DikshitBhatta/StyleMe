import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/pages/home.dart';
import 'package:stylefront/pages/onboarding/onboarding_screen.dart';
import 'package:stylefront/provider/auth_provider.dart';
import 'package:stylefront/provider/cart_provider.dart';
import 'package:stylefront/provider/favorite_provider.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:stylefront/provider/order_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cartProvider = CartProvider();
  await cartProvider.loadCart();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => cartProvider),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()..loadFavorites()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_d5d9f63743584dc38753056b0cc737d5', // Replace with actual public key
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Stylefront',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          navigatorKey: navKey, // Required for Khalti
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoading) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (authProvider.user != null) {
                return Home();
              } else {
                return OnboardingScreen();
              }
            },
          ),
        );
      },
    );
  }
}
