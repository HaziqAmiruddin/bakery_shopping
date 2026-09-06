import 'package:shopping_app/features/payment_stripe/domain/payment_method_repo.dart';
import 'package:shopping_app/features/payment_stripe/domain/saved_card_entites.dart';

class CreatePaymentSheetParamsUseCase {
  final PaymentMethodRepository repository;
  CreatePaymentSheetParamsUseCase(this.repository);
  Future<Map<String, dynamic>> call(String uid) =>
      repository.createPaymentSheetParams(uid);
}

class DeleteCardUseCase {
  final PaymentMethodRepository repository;
  DeleteCardUseCase(this.repository);
  Future<void> call(String paymentMethodId) =>
      repository.deleteCard(paymentMethodId);
}

class GetSavedCardsUseCase {
  final PaymentMethodRepository repository;
  GetSavedCardsUseCase(this.repository);
  Future<List<SavedCard>> call(String uid) => repository.getSavedCards(uid);
}
