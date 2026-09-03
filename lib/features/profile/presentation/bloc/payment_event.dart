// presentation/bloc/payment_method/payment_method_event.dart
import 'package:equatable/equatable.dart';

abstract class PaymentMethodEvent extends Equatable {
  const PaymentMethodEvent();
  @override
  List<Object?> get props => [];
}

class FetchSavedCards extends PaymentMethodEvent {
  final String uid;
  const FetchSavedCards(this.uid);
  @override
  List<Object?> get props => [uid];
}

class DeleteCardPressed extends PaymentMethodEvent {
  final String uid;
  final String paymentMethodId;
  const DeleteCardPressed(this.uid, this.paymentMethodId);
  @override
  List<Object?> get props => [uid, paymentMethodId];
}
