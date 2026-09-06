// address_state.dart
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/address/domain/address_entities.dart';

abstract class AddressState extends Equatable {
  const AddressState();
  @override
  List<Object?> get props => [];
}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<Address> addresses;
  const AddressLoaded(this.addresses);
  @override
  List<Object?> get props => [addresses];
}

class AddressError extends AddressState {
  final String message;
  const AddressError(this.message);
  @override
  List<Object?> get props => [message];
}
