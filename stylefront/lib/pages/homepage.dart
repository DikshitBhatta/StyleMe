import 'package:flutter/material.dart';
import 'package:stylefront/widgets/brands.dart';
import 'package:stylefront/widgets/featured.dart';
import 'package:stylefront/widgets/newstock.dart';
import 'package:stylefront/widgets/recommended.dart';
import 'package:stylefront/classes/titledopdown.dart';
import 'package:stylefront/methods/openpagenotifications.dart';
import 'package:stylefront/methods/openpagefavorite.dart';
import 'package:stylefront/methods/openallProduct.dart';
import 'package:stylefront/pages/home.dart';
import 'package:stylefront/pages/searchpage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Homepage extends StatefulWidget{
  const Homepage ({super.key});
  @override
  _Homepagestate createState()=> _Homepagestate();
}

class _Homepagestate extends State<Homepage>{
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _onSearchSubmitted(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(query: query),
      ),
    );
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _voiceInput = result.recognizedWords;
        });
        _onSearchSubmitted(_voiceInput);
      });
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override  
  Widget build (BuildContext context){
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        leading:GestureDetector(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=> Home()));
          },
          child:SizedBox(
          height: 10.00,
          width: 20.00,
          child: Image.asset("assets/icons/LOGOcolor.png",fit: BoxFit.contain),
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

      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
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
                      onSubmitted: _onSearchSubmitted,
                    ),
                  ),
                  GestureDetector(
                            onTap: _isListening ? _stopListening : _startListening,
                            child: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              color: Colors.black,
                            ),
                          ),
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
            ),
          ),
          if (_isListening)
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(Icons.mic, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Listening...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }}