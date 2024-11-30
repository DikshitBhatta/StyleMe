import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  const Home ({super.key});
  @override
  _Homestate createState()=> _Homestate();
}

class _Homestate extends State<Home>{
  @override  
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.pan_tool)),
        title: Text('StyleMe',
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
        ),),
        actions: <Widget>[
          IconButton(onPressed: (){}, icon: Icon(Icons.favorite,
          color: Colors.red,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.notification_add_outlined))
        ],

      ),
    );
  }
}
