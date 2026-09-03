import 'package:shopping_app/features/profile/domain/payment_method_repo.dart';

class DeleteCardUseCase {
  final PaymentMethodRepository repository;
  DeleteCardUseCase(this.repository);
  Future<void> call(String paymentMethodId) =>
      repository.deleteCard(paymentMethodId);
}
