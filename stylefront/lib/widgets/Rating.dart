import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Rating and Reviews',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: Colors.yellow,
                  );
                }),
              )
            ],
          ),
          // Wrap ListView.builder in a Container or Expanded
          SizedBox(
            height: 215.0, // Provide a fixed height for ListView.builder
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Review by user ${index+1}'),
                  subtitle: Text('Rating and name of user'),
                  trailing: Text('Photo of product'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
