import 'package:flutter/material.dart';

class Favorites extends StatefulWidget{
  const Favorites ({super.key});
  @override
  _FavoritesState createState()=> _FavoritesState();
}

class _FavoritesState extends State<Favorites>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Favorites',),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){},
        ),
      ],),
      body: Center(
        child: Text('Favorites'),
      ),
    );
  }
}