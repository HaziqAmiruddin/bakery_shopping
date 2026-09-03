import 'package:shopping_app/features/profile/domain/payment_method_repo.dart';
import 'package:shopping_app/features/profile/domain/saved_card_entites.dart';

class GetSavedCardsUseCase {
  final PaymentMethodRepository repository;
  GetSavedCardsUseCase(this.repository);
  Future<List<SavedCard>> call(String uid) => repository.getSavedCards(uid);
}
