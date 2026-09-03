// presentation/bloc/payment_method/payment_method_state.dart
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/profile/domain/saved_card_entites.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();
  @override
  List<Object?> get props => [];
}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodLoaded extends PaymentMethodState {
  final List<SavedCard> cards;
  const PaymentMethodLoaded(this.cards);
  @override
  List<Object?> get props => [cards];
}

class PaymentMethodError extends PaymentMethodState {
  final String message;
  const PaymentMethodError(this.message);
  @override
  List<Object?> get props => [message];
}
