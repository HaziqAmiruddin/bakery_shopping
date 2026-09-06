// domain/repositories/payment_method_repository.dart
import 'package:shopping_app/features/payment_stripe/domain/saved_card_entites.dart';

abstract class PaymentMethodRepository {
  Future<List<SavedCard>> getSavedCards(String uid);
  Future<Map<String, dynamic>> createPaymentSheetParams(String uid);
  Future<void> deleteCard(String paymentMethodId);
}
