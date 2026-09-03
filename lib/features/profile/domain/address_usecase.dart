import 'package:shopping_app/features/profile/domain/address_entities.dart';
import 'package:shopping_app/features/profile/domain/address_repo.dart';

class WatchAddressesUseCase {
  final AddressRepository repository;
  WatchAddressesUseCase(this.repository);
  Stream<List<Address>> call() => repository.watchAddresses();
}

class AddAddressUseCase {
  final AddressRepository repository;
  AddAddressUseCase(this.repository);
  Future<void> call(Address address) => repository.addAddress(address);
}

class UpdateAddressUseCase {
  final AddressRepository repository;
  UpdateAddressUseCase(this.repository);
  Future<void> call(Address address) => repository.updateAddress(address);
}

class DeleteAddressUseCase {
  final AddressRepository repository;
  DeleteAddressUseCase(this.repository);
  Future<void> call(String addressId) => repository.deleteAddress(addressId);
}

class SetDefaultAddressUseCase {
  final AddressRepository repository;
  SetDefaultAddressUseCase(this.repository);
  Future<void> call(String addressId) =>
      repository.setDefaultAddress(addressId);
}
