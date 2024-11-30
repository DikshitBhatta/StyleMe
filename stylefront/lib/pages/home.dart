import 'package:flutter/material.dart';
import 'package:stylefront/classes/titledopdown.dart';
import 'package:stylefront/methods/openpagenotifications.dart';
import 'package:stylefront/pages/profile.dart';
import 'package:stylefront/pages/scale.dart';
import 'package:stylefront/pages/shop.dart';
import 'package:stylefront/methods/openpagefavorite.dart';

class Home extends StatefulWidget{
  const Home ({super.key});
  @override
  _Homestate createState()=> _Homestate();
}

class _Homestate extends State<Home>{
  int selectedIndex=0;
  final List _listpages = [];
  Widget? currentPage;
  @override
  void initState(){
    super.initState();
    _listpages
    ..add(Home())
    ..add(Scale())
    ..add(Shop())
    ..add(Profile());
    currentPage = Home();
  }
  void changePage(int index){
    setState(() {
      selectedIndex = index;
      currentPage = _listpages[index];
    });
  }
  @override  
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.pan_tool)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[ Text('StyleMe',
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
        ),),
        //IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down),),
        PopupMenuButton<Titledropdown>(
          icon: Icon(Icons.arrow_drop_down),
          onSelected: ((valueselected){ print('${valueselected.title}');}),
          itemBuilder: (BuildContext context){
            return Catalogue.map((Titledropdown titledropdown){
              return PopupMenuItem<Titledropdown>(
                value: titledropdown,
                child: Row(
                  children: <Widget>[
                    Text(titledropdown.title!)
                  ],
                )
              );
            }).toList();
          })
        ],),
        actions: <Widget>[
          IconButton(onPressed: () => openpagefavorite(context), icon: Icon(Icons.favorite,
          color: Colors.red,)),
          IconButton(onPressed: ()=> openpagenotifications(context), icon: Icon(Icons.notification_add_outlined))
        ], 

      ),
      body: 
      SingleChildScrollView(
        child:SafeArea(
           child:Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child:Container(
            margin: EdgeInsets.only(top: 16.0),
            padding: EdgeInsets.symmetric(horizontal:8.0,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  offset: Offset(0,4),
                  blurRadius: 8.0
                )
              ],
            ),
          child: Row(
            children: <Widget>[
              Icon(Icons.search),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '''Search''',
                    border: InputBorder.none,
                  ),
                ),
              ),
              Icon(Icons.mic,
              color: Colors.black,),
            ],
          ),
          ) ,
              ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.all(15.00),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('RECOMMENDED',
                style: TextStyle(fontSize: 30.0),),
              const SizedBox(height: 10.0),
              Text('NEW IN STOCKS',
                style: TextStyle(fontSize: 30.0),),
              const SizedBox(height: 10.0),

              Text('BRANDS',
                style: TextStyle(fontSize: 30.0),),
              const SizedBox(height: 10.0),
              Text('FEATURED',
                style: TextStyle(fontSize: 30.0),),
            ],
          ),
        )
         
            ],
           ),
        ),),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color:Colors.black),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.scale_rounded,color:Colors.black),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shop_2_rounded,color:Colors.black),label: ''),
          BottomNavigationBarItem(icon:Icon(Icons.person,color:Colors.black),label: ''),
        ]),
    );
  }
}
