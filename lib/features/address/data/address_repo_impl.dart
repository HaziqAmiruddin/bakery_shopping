import 'package:shopping_app/features/address/data/address_remote_data_sources.dart';
import 'package:shopping_app/features/address/domain/address_entities.dart';
import 'package:shopping_app/features/address/domain/address_repo.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl({required AddressRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AddressRemoteDataSource _remoteDataSource;

  @override
  Stream<List<Address>> watchAddresses() => _remoteDataSource.watchAddresses();

  @override
  Future<void> addAddress(Address address) =>
      _remoteDataSource.addAddress(address);

  @override
  Future<void> updateAddress(Address address) =>
      _remoteDataSource.updateAddress(address);

  @override
  Future<void> deleteAddress(String addressId) =>
      _remoteDataSource.deleteAddress(addressId);

  @override
  Future<void> setDefaultAddress(String addressId) =>
      _remoteDataSource.setDefaultAddress(addressId);
}
