import 'package:flutter/material.dart';
import 'package:stylefront/widgets/brands.dart';
import 'package:stylefront/widgets/featured.dart';
import 'package:stylefront/widgets/newstock.dart';
import 'package:stylefront/widgets/recommended.dart';
import 'package:stylefront/utility/csv.dart';
import 'package:stylefront/models/datamodels.dart';
import 'package:stylefront/classes/titledopdown.dart';
import 'package:stylefront/methods/openpagenotifications.dart';
import 'package:stylefront/methods/openpagefavorite.dart';
import 'package:stylefront/methods/openallProduct.dart';

class Homepage extends StatefulWidget{
  const Homepage ({super.key});
  @override
  _Homepagestate createState()=> _Homepagestate();
}

class _Homepagestate extends State<Homepage>{


  @override  
  Widget build (BuildContext context){
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        leading:GestureDetector(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=> Homepage()));
          },
          child:SizedBox(
          height: 10.00,
          width: 20.00,
          child: Image.asset('assets/icons/LOGO_cropped.png',fit: BoxFit.contain),
          ),
        ) ,
        
        
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[ Text('StyleMe',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
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
          IconButton(onPressed: ()=> openpagenotifications(context), icon: Icon(Icons.notification_add_outlined)),
          IconButton(onPressed: ()=> openallProduct(context), icon: Icon(Icons.all_out)),
        ], 

      ),

      body:SingleChildScrollView(
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
           RecommendedSection(),
           SizedBox(height: 10,),
           NewInStockSection(),
           SizedBox(height: 10,),   
           BrandsSection(),
            SizedBox(height: 10,),
           FeaturedSection(),
         
            ],
           ),
        ),));
  }}