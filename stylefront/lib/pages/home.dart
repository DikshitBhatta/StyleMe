import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stylefront/pages/profile.dart';
import 'package:stylefront/pages/scale.dart';
import 'package:stylefront/pages/shop.dart';
import 'package:stylefront/pages/homepage.dart';

class Home extends StatefulWidget{
  const Home ({super.key});
  @override
  _Homestate createState()=> _Homestate();
}

class _Homestate extends State<Home>{
  int selectedIndex=0;
  final List _listpages = [Homepage(),Scale(),Cart(),Profile()];
  Widget? currentPage;
  @override
  void initState(){
    super.initState();
    currentPage=_listpages[selectedIndex];

  }

  void changePage(int index){
    setState(() {
      selectedIndex = index;
      currentPage = _listpages[index];
    });
  }

  Future<void> _refreshPage() async{
    await Future.delayed(const Duration(seconds: 1));
  }

  @override  
  Widget build (BuildContext context){
    return Scaffold(
      body: RefreshIndicator(child:currentPage! , onRefresh: _refreshPage,) ,
      
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: changePage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,),label: ''),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.ruler,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined,),label: ''),
          BottomNavigationBarItem(icon:Icon(Icons.person,),label: ''),
          
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        ),
    );
  }
}




