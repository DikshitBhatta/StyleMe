import 'package:flutter/material.dart';
import 'package:stylefront/methods/openpagefavorite.dart';
import 'package:stylefront/widgets/favorites.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        const Text(
          'Favorites',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 220, 
          child: Favorites(),
        ),
        const SizedBox(height: 20.0),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => openpagefavorite(context),
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
