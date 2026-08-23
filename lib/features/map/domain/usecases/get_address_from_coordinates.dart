import 'package:shopping_app/features/map/domain/repository/location_repo.dart';

class GetAddressFromCoordinates {
  final LocationRepository repository;
  GetAddressFromCoordinates(this.repository);

  Future<String> call(double lat, double lng) =>
      repository.getAddressFromCoordinates(lat, lng);
}
