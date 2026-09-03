import 'package:shopping_app/features/profile/domain/address_entities.dart';

abstract class AddressRepository {
  Stream<List<Address>> watchAddresses();
  Future<void> addAddress(Address address);
  Future<void> updateAddress(Address address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
}
