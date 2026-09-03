import 'package:shopping_app/features/profile/data/payment_method_api_service.dart';
import 'package:shopping_app/features/profile/domain/payment_method_repo.dart';
import 'package:shopping_app/features/profile/domain/saved_card_entites.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  PaymentMethodRepositoryImpl({required PaymentMethodApiService apiService})
    : _apiService = apiService;

  final PaymentMethodApiService _apiService;

  @override
  Future<List<SavedCard>> getSavedCards(String uid) =>
      _apiService.getSavedCards(uid);

  @override
  Future<Map<String, dynamic>> createPaymentSheetParams(String uid) =>
      _apiService.createPaymentSheetParams(uid);

  @override
  Future<void> deleteCard(String paymentMethodId) =>
      _apiService.deleteCard(paymentMethodId);
}
