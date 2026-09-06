import 'package:shopping_app/features/helpsupport/domain/chat_message_entities.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_repo.dart';

class SendSupportMessageUseCase {
  final SupportChatRepository repository;
  SendSupportMessageUseCase(this.repository);

  Future<String> call(String message, List<ChatMessage> history) =>
      repository.sendMessage(message, history);
}
