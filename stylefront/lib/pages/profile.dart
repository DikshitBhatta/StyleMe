import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:stylefront/methods/openpagefavorite.dart';
import 'package:stylefront/widgets/settings.dart';
import 'package:stylefront/widgets/favorites.dart';
import 'package:stylefront/widgets/overview.dart';
import 'package:stylefront/pages/authentication/signin.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showSettings = false;

  // Variable to store the username
  String? username;

  @override
  void initState() {
    super.initState();
    // Fetch the current user's display name
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      username = user?.displayName ?? 'User';
    });
  }

  void toggleView(bool showSettings) {
    setState(() {
      this.showSettings = showSettings;
    });
  }

  // Method to handle sign out
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to SignInScreen and remove all previous routes
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      // Handle sign out errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
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
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.jpg', // Add profile image
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person_2,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Hello, ${username ?? 'User'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Navigation Buttons: Overview and Settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    toggleView(false);
                  },
                  child: Column(
                    children: [
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Divider(
                        color: showSettings ? Colors.grey : Colors.black,
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
                  child: Column(
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Divider(
                        color: showSettings ? Colors.black : Colors.grey,
                        thickness: 2,
                        height: 1,
                        endIndent: 20,
                        indent: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Conditional Rendering: Settings or Overview
            showSettings ? const Settings() : const Overview(),
            const SizedBox(height: 40.0),
            // Sign Out Button
            Center(
              child: ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space at the bottom
          ],
        ),
      ),
    );
  }
}