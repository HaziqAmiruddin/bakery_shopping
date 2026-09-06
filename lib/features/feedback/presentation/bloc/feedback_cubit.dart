// feedback_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/feedback/domain/feedback_entities.dart';
import 'package:shopping_app/features/feedback/domain/feedback_usecase.dart';
import 'package:shopping_app/features/feedback/presentation/bloc/feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final SubmitFeedbackUseCase submitFeedbackUseCase;

  FeedbackCubit({required this.submitFeedbackUseCase}) : super(FeedbackIdle());

  Future<void> submit(AppFeedback feedback) async {
    emit(FeedbackSubmitting());
    try {
      await submitFeedbackUseCase(feedback);
      emit(FeedbackSubmitted());
    } catch (e) {
      emit(FeedbackSubmitError(e.toString()));
    }
  }
}
