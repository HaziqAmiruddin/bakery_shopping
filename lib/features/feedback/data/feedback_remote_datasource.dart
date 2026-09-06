import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/features/feedback/domain/feedback_entities.dart';

class FeedbackRemoteDataSource {
  FeedbackRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<void> submitFeedback(AppFeedback feedback) async {
    await _firestore.collection('feedback').add(feedback.toFirestore());
  }
}
