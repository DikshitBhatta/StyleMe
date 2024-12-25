import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:stylefront/provider/homepagestate.dart';
import 'package:stylefront/pages/categories.dart';
import 'package:stylefront/pages/new_products.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(query: query),
      ),
    );
  }

  Future<void> _onCategorySelected(BuildContext context, String category) async {
    if (category == 'Collections') {
      await openallProduct(context);
    } else if (category == 'New Products') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewProductsPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoriesPage(category: category),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomepageState(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: SizedBox(
              height: 10.00,
              width: 20.00,
              child: Image.asset("assets/icons/LOGOcolor.png", fit: BoxFit.contain),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'StyleMe',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              PopupMenuButton<Titledropdown>(
                icon: Icon(Icons.arrow_drop_down),
                onSelected: (valueselected) {
                  _onCategorySelected(context, valueselected.title!);
                },
                itemBuilder: (BuildContext context) {
                  return Catalogue.map((Titledropdown titledropdown) {
                    return PopupMenuItem<Titledropdown>(
                      value: titledropdown,
                      child: Row(
                        children: <Widget>[Text(titledropdown.title!)],
                      ),
                    );
                  }).toList();
                },
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () => openpagefavorite(context),
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () => openpagenotifications(context),
              icon: Icon(Icons.notification_add_outlined),
            ),
            IconButton(
              onPressed: () => openallProduct(context),
              icon: Icon(Icons.all_out),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 16.0),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: Offset(0, 4),
                              blurRadius: 8.0,
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
                                onSubmitted: (query) => _onSearchSubmitted(context, query),
                              ),
                            ),
                            Consumer<HomepageState>(
                              builder: (context, state, child) {
                                return GestureDetector(
                                  onTap: state.isListening
                                      ? state.stopListening
                                      : () => state.startListening((query) => _onSearchSubmitted(context, query)),
                                  child: Icon(
                                    state.isListening ? Icons.mic : Icons.mic_none,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    RecommendedSection(),
                    SizedBox(height: 10),
                    NewInStockSection(),
                    SizedBox(height: 10),
                    BrandsSection(),
                    SizedBox(height: 10),
                    FeaturedSection(),
                  ],
                ),
              ),
            ),
            Consumer<HomepageState>(
              builder: (context, state, child) {
                if (state.isListening) {
                  return Positioned(
                    bottom: 20,
                    left: MediaQuery.of(context).size.width / 2 - 30,
                    child: ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.2).animate(_animationController),
                      child: FloatingActionButton(
                        onPressed: state.stopListening,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.mic, color: Colors.white),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}