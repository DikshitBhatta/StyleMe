import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stylefront/pages/profile.dart';
import 'package:stylefront/pages/scale.dart';
import 'package:stylefront/pages/shop.dart';
import 'package:stylefront/pages/homepage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _Homestate createState() => _Homestate();
}

class _Homestate extends State<Home> {
  int selectedIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  late List<Widget> _listpages;

  @override
  void initState() {
    super.initState();
    _listpages = <Widget>[
      PageStorage(key: PageStorageKey('Homepage'), bucket: bucket, child: Homepage()),
      Scale(),
      Cart(),
      Profile(),
    ];
  }

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _refreshPage() async {
    await Future.delayed(const Duration(seconds: 0));
    // Force reload the app
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: IndexedStack(
          index: selectedIndex,
          children: _listpages,
        ),
        onRefresh: _refreshPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: changePage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.ruler), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}




