import 'package:shopping_app/features/feedback/data/feedback_remote_datasource.dart';
import 'package:shopping_app/features/feedback/domain/feedback_entities.dart';
import 'package:shopping_app/features/feedback/domain/feedback_repo.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl({required FeedbackRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final FeedbackRemoteDataSource _remoteDataSource;

  @override
  Future<void> submitFeedback(AppFeedback feedback) =>
      _remoteDataSource.submitFeedback(feedback);
}
