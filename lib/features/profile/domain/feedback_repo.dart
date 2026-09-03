import 'package:shopping_app/features/profile/domain/feedback_entities.dart';

abstract class FeedbackRepository {
  Future<void> submitFeedback(AppFeedback feedback);
}
