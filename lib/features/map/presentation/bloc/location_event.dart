import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object?> get props => [];
}

class FetchCurrentLocation extends LocationEvent {}

class SelectLocationOnMap extends LocationEvent {
  final double latitude;
  final double longitude;
  const SelectLocationOnMap(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

class ConfirmSelectedLocation extends LocationEvent {}

class SearchLocation extends LocationEvent {
  final String query;
  const SearchLocation(this.query);

  @override
  List<Object?> get props => [query];
}
