import 'package:shopping_app/features/map/domain/entities/location_entities.dart';
import 'package:shopping_app/features/map/domain/repository/location_repo.dart';

class GetCurrentLocation {
  final LocationRepository repository;
  GetCurrentLocation(this.repository);

  Future<LocationEntity> call() => repository.getCurrentLocation();
}
