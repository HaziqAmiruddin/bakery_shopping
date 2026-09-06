import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/API/api_key.dart';

class XenditApiService {
  static const _baseUrl = ApiKey.baseUrl; // your Render URL

  Future<Map<String, dynamic>> createInvoice({
    required String uid,
    required double amount,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-xendit-invoice'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': uid, 'amount': amount, 'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create invoice: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
