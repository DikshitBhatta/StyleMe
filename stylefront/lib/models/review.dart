import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String userName;
  final int rating; // Change type to int
  final String reviewText;
  final String? imageUrl; // This will store the base64 string
  final DateTime timestamp;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.reviewText,
    this.imageUrl,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      userId: data['userId'],
      userName: data['userName'],
      rating: data['rating'], // Ensure this is an int
      reviewText: data['reviewText'],
      imageUrl: data['imageUrl'], // This should be a base64 string
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'reviewText': reviewText,
      'imageUrl': imageUrl, // This should be a base64 string
      'timestamp': Timestamp.fromDate(timestamp), // Ensure timestamp is correctly formatted
    };
  }
}