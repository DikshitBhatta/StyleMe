import 'package:flutter/material.dart';
import 'package:stylefront/models/review.dart';
import 'package:stylefront/methods/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:stylefront/provider/order_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;

class Rating extends StatefulWidget {
  final String productId;

  const Rating({super.key, required this.productId});

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final _reviewController = TextEditingController();
  double _rating = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  List<Review> _reviews = [];
  Review? _userReview;
  bool _isEditing = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<String?> _encodeImageToBase64(XFile imageFile) async {
    try {
      final bytes = await File(imageFile.path).readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image != null) {
        img.Image resizedImage = img.copyResize(image, width: 800); // Resize the image
        final resizedBytes = img.encodeJpg(resizedImage, quality: 85); // Adjust quality if needed
        return base64Encode(resizedBytes);
      }
      return null;
    } catch (e) {
      print('Error encoding image: $e');
      return null;
    }
  }

  void _submitReview() async {
    if (user == null) return;

    String? imageBase64;
    if (_imageFile != null) {
      imageBase64 = await _encodeImageToBase64(_imageFile!);
    }

    final reviewId = _userReview?.id ?? FirebaseFirestore.instance.collection('products').doc(widget.productId).collection('reviews').doc().id;
    final review = Review(
      id: reviewId,
      userId: user!.uid,
      userName: user!.displayName ?? 'Anonymous',
      rating: _rating.toInt(),
      reviewText: _reviewController.text,
      timestamp: DateTime.now(),
      imageUrl: imageBase64,
    );
    await addReview(widget.productId, review);
    _reviewController.clear();
    setState(() {
      _rating = 0;
      _imageFile = null;
      _userReview = review;
      _isEditing = false;
    });
  }

  void _deleteReview(String reviewId) async {
    await deleteReview(widget.productId, reviewId);
    setState(() {
      _userReview = null;
      _reviewController.clear();
      _rating = 0;
      _imageFile = null;
      _isEditing = false;
    });
  }

  void _editReview(Review review) {
    setState(() {
      _reviewController.text = review.reviewText;
      _rating = review.rating.toDouble();
      _userReview = review;
      _isEditing = true;
    });
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < _rating ? Icons.star : Icons.star_border,
        color: index < _rating ? Colors.yellow : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1.0;
        });
      },
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.memory(base64Decode(imageUrl)),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                iconSize: 30,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadReviews() {
    getReviews(widget.productId).listen((List<Review> reviews) {
      setState(() {
        _reviews = reviews;
        try {
          _userReview = reviews.firstWhere((review) => review.userId == user?.uid);
        } catch (e) {
          _userReview = null;
        }

        if (_userReview != null) {
          _reviewController.text = _userReview!.reviewText;
          _rating = _userReview!.rating.toDouble();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasBoughtProduct = Provider.of<OrderProvider>(context).hasBoughtProduct(widget.productId);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<Review>>(
            stream: getReviews(widget.productId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading reviews'));
              }

              final reviews = snapshot.data ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Rating and Reviews',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (reviews.isEmpty)
                    Center(child: Text('No reviews yet.')),
                  SizedBox(
                    height: 215.0,
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (BuildContext context, int index) {
                        final review = reviews[index];
                        return ListTile(
                          title: Row(
                            children: [
                              Text(review.userName),
                              SizedBox(width: 8),
                              Text('★ ${review.rating} '),
                              Spacer(),
                              if (review.userId == user?.uid) ...[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editReview(review),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteReview(review.id),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.reviewText),
                              if (review.imageUrl != null)
                                GestureDetector(
                                  onTap: () => _showImageDialog(review.imageUrl!),
                                  child: Image.memory(
                                    base64Decode(review.imageUrl!),
                                    width: 150,
                                    height: 100,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          if (user != null && hasBoughtProduct && _userReview == null) 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write a Review',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Stack(
                    children: [
                      TextField(
                        controller: _reviewController,
                        decoration: InputDecoration(
                          labelText: 'Your Review',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: List.generate(5, (index) => _buildStar(index)),
                  ),
                  SizedBox(height: 8.0),
                  if (_imageFile != null)
                    Image.file(
                      File(_imageFile!.path),
                      width: 100,
                      height: 100,
                    ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text('Submit Review'),
                  ),
                ],
              ),
            ),
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Your Review',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Stack(
                    children: [
                      TextField(
                        controller: _reviewController,
                        decoration: InputDecoration(
                          labelText: 'Your Review',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: List.generate(5, (index) => _buildStar(index)),
                  ),
                  SizedBox(height: 8.0),
                  if (_imageFile != null)
                    Image.file(
                      File(_imageFile!.path),
                      width: 100,
                      height: 100,
                    ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text('Update Review'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
