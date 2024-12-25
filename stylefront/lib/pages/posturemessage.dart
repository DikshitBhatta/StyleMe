import 'package:flutter/material.dart';

class PostureMessagePage extends StatelessWidget {
  final VoidCallback onProceed;

  PostureMessagePage({required this.onProceed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posture Message'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Please stand in the correct posture as shown in the guide image for accurate measurements. Improper posture may cause errors.',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Image.asset(
              'assets/posture/posture.png',
              width: 600, 
              height: 500, 
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF023C45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
              onPressed: onProceed,
              child: Text('Proceed to Measurement' , style: TextStyle( color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
