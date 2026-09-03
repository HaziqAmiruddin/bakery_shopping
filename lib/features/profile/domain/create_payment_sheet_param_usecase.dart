import 'package:shopping_app/features/profile/domain/payment_method_repo.dart';

class CreatePaymentSheetParamsUseCase {
  final PaymentMethodRepository repository;
  CreatePaymentSheetParamsUseCase(this.repository);
  Future<Map<String, dynamic>> call(String uid) =>
      repository.createPaymentSheetParams(uid);
}
