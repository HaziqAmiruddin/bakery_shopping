// address_event.dart
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/address/domain/address_entities.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();
  @override
  List<Object?> get props => [];
}

class WatchAddressesStarted extends AddressEvent {}

class AddressAdded extends AddressEvent {
  final Address address;
  const AddressAdded(this.address);
  @override
  List<Object?> get props => [address];
}

class AddressUpdated extends AddressEvent {
  final Address address;
  const AddressUpdated(this.address);
  @override
  List<Object?> get props => [address];
}

class AddressDeleted extends AddressEvent {
  final String addressId;
  const AddressDeleted(this.addressId);
  @override
  List<Object?> get props => [addressId];
}

class AddressSetDefault extends AddressEvent {
  final String addressId;
  const AddressSetDefault(this.addressId);
  @override
  List<Object?> get props => [addressId];
}
