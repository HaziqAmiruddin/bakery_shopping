import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_message_entities.dart';

abstract class SupportChatState extends Equatable {
  const SupportChatState();
  @override
  List<Object?> get props => [];
}

class SupportChatReady extends SupportChatState {
  final List<ChatMessage> messages;
  final bool isSending;

  const SupportChatReady({this.messages = const [], this.isSending = false});

  SupportChatReady copyWith({List<ChatMessage>? messages, bool? isSending}) {
    return SupportChatReady(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [messages, isSending];
}
