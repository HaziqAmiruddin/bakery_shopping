import 'package:shopping_app/features/feedback/domain/feedback_entities.dart';

abstract class FeedbackRepository {
  Future<void> submitFeedback(AppFeedback feedback);
}
