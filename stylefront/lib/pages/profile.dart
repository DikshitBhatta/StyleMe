import 'package:flutter/material.dart';
import 'package:stylefront/widgets/settings.dart';
import 'package:stylefront/widgets/overview.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showSettings = false;

  void toggleView(bool showSettings) {
    setState(() {
      this.showSettings = showSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Image.asset('assets/images/profile.jpg',//add profile image
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person_2,size: 50.00,color: Colors.grey,),),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Hello, Emilia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    toggleView(false);
                  },
                  child: Column(
                    children: const [
                      Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Divider(
                        color: Colors.black,
                        thickness: 2,
                        height: 1,
                        endIndent: 20,
                        indent: 20,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    toggleView(true);
                  },
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            showSettings ? const Settings() : const Overview(), 
          ],
        ),
      ),
    );
  }
}
