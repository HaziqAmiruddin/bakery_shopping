// feedback_state.dart
import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();
  @override
  List<Object?> get props => [];
}

class FeedbackIdle extends FeedbackState {}

class FeedbackSubmitting extends FeedbackState {}

class FeedbackSubmitted extends FeedbackState {}

class FeedbackSubmitError extends FeedbackState {
  final String message;
  const FeedbackSubmitError(this.message);
  @override
  List<Object?> get props => [message];
}
