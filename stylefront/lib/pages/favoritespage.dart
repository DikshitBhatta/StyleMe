import 'package:flutter/material.dart';
import 'package:stylefront/widgets/favorites.dart'; 

class Favoritespage extends StatefulWidget {
  const Favoritespage({super.key});

  @override
  _FavoritespageState createState() => _FavoritespageState();
}

class _FavoritespageState extends State<Favoritespage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritespage'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Favorites(), 
    );
  }
}
