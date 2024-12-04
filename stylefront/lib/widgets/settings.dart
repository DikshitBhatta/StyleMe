import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

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
            onPressed: () {},
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
