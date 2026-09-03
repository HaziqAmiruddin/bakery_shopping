import 'package:shopping_app/features/profile/domain/feedback_entities.dart';
import 'package:shopping_app/features/profile/domain/feedback_repo.dart';

class SubmitFeedbackUseCase {
  final FeedbackRepository repository;
  SubmitFeedbackUseCase(this.repository);
  Future<void> call(AppFeedback feedback) =>
      repository.submitFeedback(feedback);
}
