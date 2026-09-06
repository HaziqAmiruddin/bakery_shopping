import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_message_entities.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_usecase.dart';
import 'package:shopping_app/features/helpsupport/presentation/bloc/chat_state.dart';

class SupportChatCubit extends Cubit<SupportChatState> {
  final SendSupportMessageUseCase sendSupportMessageUseCase;

  SupportChatCubit({required this.sendSupportMessageUseCase})
    : super(const SupportChatReady());

  Future<void> sendMessage(String text) async {
    final current = state as SupportChatReady;
    final userMessage = ChatMessage(role: ChatRole.user, text: text);
    final updatedMessages = [...current.messages, userMessage];

    emit(current.copyWith(messages: updatedMessages, isSending: true));

    try {
      final reply = await sendSupportMessageUseCase(text, current.messages);
      final botMessage = ChatMessage(role: ChatRole.model, text: reply);

      emit(
        SupportChatReady(
          messages: [...updatedMessages, botMessage],
          isSending: false,
        ),
      );
    } catch (e) {
      debugPrint('Support chat error: $e');
      final errorMessage = ChatMessage(
        role: ChatRole.model,
        text:
            "Sorry, I'm having trouble connecting right now. Please try again.",
      );
      emit(
        SupportChatReady(
          messages: [...updatedMessages, errorMessage],
          isSending: false,
        ),
      );
    }
  }
}
