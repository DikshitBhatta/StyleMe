import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stylefront/models/review.dart';

Future<void> addReview(String productId, Review review) async {
  await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .collection('reviews')
      .doc(review.id)
      .set(review.toFirestore());
}

Future<void> deleteReview(String productId, String reviewId) async {
  await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .collection('reviews')
      .doc(reviewId)
      .delete();
}

Stream<List<Review>> getReviews(String productId) {
  return FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .collection('reviews')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList());
}