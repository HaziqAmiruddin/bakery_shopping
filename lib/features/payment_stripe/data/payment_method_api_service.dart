import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/API/api_key.dart';
import 'package:shopping_app/features/payment_stripe/domain/saved_card_entites.dart';

class PaymentMethodApiService {
  Future<Map<String, dynamic>> createPaymentSheetParams(String uid) async {
    final response = await http.post(
      Uri.parse('${ApiKey.baseUrl}/create-payment-sheet'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': uid}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to init payment sheet: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<SavedCard>> getSavedCards(String uid) async {
    final response = await http.get(
      Uri.parse('${ApiKey.baseUrl}/payment-methods/$uid'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch cards: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['paymentMethods'] as List)
        .map((json) => SavedCard.fromJson(json))
        .toList();
  }

  Future<void> deleteCard(String paymentMethodId) async {
    final response = await http.delete(
      Uri.parse('${ApiKey.baseUrl}/payment-methods/$paymentMethodId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete card: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required String uid,
    required double amount, // in RM, e.g. 25.00
  }) async {
    final amountInSen = (amount * 100).round();

    final response = await http.post(
      Uri.parse('${ApiKey.baseUrl}/create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'uid': uid, 'amount': amountInSen}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment intent: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
