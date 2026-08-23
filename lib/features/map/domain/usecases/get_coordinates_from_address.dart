import 'package:shopping_app/features/map/domain/entities/location_entities.dart';
import 'package:shopping_app/features/map/domain/repository/location_repo.dart';

class GetCoordinatesFromAddress {
  final LocationRepository repository;
  GetCoordinatesFromAddress(this.repository);

  Future<LocationEntity> call(String address) =>
      repository.getCoordinatesFromAddress(address);
}
