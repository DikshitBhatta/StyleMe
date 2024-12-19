import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylefront/pages/authentication/signin.dart'; 

class Settings extends StatelessWidget {
  const Settings({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        buildSettingsOption(
          context,
          icon: Icons.person_outline,
          title: 'Personal information',
          onTap: () {},
        ),
        buildSettingsOption(
          context,
          icon: Icons.shopping_bag_outlined,
          title: 'Orders',
          onTap: () {},
        ),
        buildSettingsOption(
          context,
          icon: Icons.security_outlined,
          title: 'Privacy Policy',
          onTap: () {},
        ),
        buildSettingsOption(
          context,
          icon: Icons.language_outlined,
          title: 'Location & Language',
          onTap: () {},
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () => _signOut(context), // Use the method within the widget
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.pink),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Log out',
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
