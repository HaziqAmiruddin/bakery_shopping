import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopping_app/features/map/domain/entities/location_entities.dart';
import 'package:shopping_app/features/map/domain/repository/location_repo.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<LocationEntity> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final address = await getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return LocationEntity(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
    );
  }

  @override
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return 'Unknown location';
      final p = placemarks.first;
      final sub = (p.subLocality?.isNotEmpty == true)
          ? p.subLocality
          : p.locality;
      return '$sub, ${p.administrativeArea}';
    } catch (_) {
      return 'Unknown location';
    }
  }

  @override
  Future<LocationEntity> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        throw Exception('Location not found for "$address"');
      }
      final loc = locations.first;
      final resolvedAddress = await getAddressFromCoordinates(
        loc.latitude,
        loc.longitude,
      );
      return LocationEntity(
        latitude: loc.latitude,
        longitude: loc.longitude,
        address: resolvedAddress,
      );
    } catch (_) {
      throw Exception('Could not find location for "$address"');
    }
  }
}
