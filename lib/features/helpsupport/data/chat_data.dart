import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/API/api_key.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_message_entities.dart';

class SupportChatApiService {
  static const _baseUrl = ApiKey.baseUrl;

  Future<String> sendMessage(String message, List<ChatMessage> history) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/support-chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': message,
        'history': history
            .map(
              (m) => {
                'role': m.role == ChatRole.user ? 'user' : 'model',
                'text': m.text,
              },
            )
            .toList(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get response: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['reply'] as String;
  }
}
