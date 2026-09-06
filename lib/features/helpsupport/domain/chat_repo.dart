import 'package:shopping_app/features/helpsupport/domain/chat_message_entities.dart';

abstract class SupportChatRepository {
  Future<String> sendMessage(String message, List<ChatMessage> history);
}
