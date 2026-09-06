import 'package:shopping_app/features/helpsupport/data/chat_data.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_message_entities.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_repo.dart';

class SupportChatRepositoryImpl implements SupportChatRepository {
  SupportChatRepositoryImpl({required SupportChatApiService apiService})
    : _apiService = apiService;

  final SupportChatApiService _apiService;

  @override
  Future<String> sendMessage(String message, List<ChatMessage> history) =>
      _apiService.sendMessage(message, history);
}
