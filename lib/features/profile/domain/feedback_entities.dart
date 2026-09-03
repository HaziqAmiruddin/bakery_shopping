import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum FeedbackCategory { bug, suggestion, other }

class AppFeedback extends Equatable {
  final String uid;
  final String userEmail;
  final int rating;
  final FeedbackCategory category;
  final String message;

  const AppFeedback({
    required this.uid,
    required this.userEmail,
    required this.rating,
    required this.category,
    required this.message,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'userEmail': userEmail,
      'rating': rating,
      'category': category.name,
      'message': message,
      'status': 'new',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  List<Object?> get props => [uid, userEmail, rating, category, message];
}
