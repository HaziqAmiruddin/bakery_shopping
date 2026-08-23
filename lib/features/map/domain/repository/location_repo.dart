import 'package:shopping_app/features/map/domain/entities/location_entities.dart';

abstract class LocationRepository {
  Future<LocationEntity> getCurrentLocation();
  Future<String> getAddressFromCoordinates(double lat, double lng);
  Future<LocationEntity> getCoordinatesFromAddress(String address);
}
