import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/map/domain/entities/location_entities.dart';
import 'package:shopping_app/features/map/domain/usecases/get_address_from_coordinates.dart';
import 'package:shopping_app/features/map/domain/usecases/get_coordinates_from_address.dart';
import 'package:shopping_app/features/map/domain/usecases/get_current_location.dart';
import 'package:shopping_app/features/map/presentation/bloc/location_event.dart';
import 'package:shopping_app/features/map/presentation/bloc/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final GetAddressFromCoordinates getAddressFromCoordinates;
  final GetCoordinatesFromAddress getCoordinatesFromAddress;

  LocationEntity? _pendingLocation;

  LocationBloc({
    required this.getCurrentLocation,
    required this.getAddressFromCoordinates,
    required this.getCoordinatesFromAddress,
  }) : super(LocationInitial()) {
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
    on<SelectLocationOnMap>(_onSelectLocationOnMap);
    on<SearchLocation>(_onSearchLocation);
    on<ConfirmSelectedLocation>(_onConfirmSelectedLocation);
  }

  Future<void> _onFetchCurrentLocation(
    FetchCurrentLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final location = await getCurrentLocation();
      _pendingLocation = location;
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onSelectLocationOnMap(
    SelectLocationOnMap event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final address = await getAddressFromCoordinates(
        event.latitude,
        event.longitude,
      );
      final location = LocationEntity(
        latitude: event.latitude,
        longitude: event.longitude,
        address: address,
      );
      _pendingLocation = location;
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void _onConfirmSelectedLocation(
    ConfirmSelectedLocation event,
    Emitter<LocationState> emit,
  ) {
    if (_pendingLocation != null) {
      emit(LocationConfirmed(_pendingLocation!));
    }
  }

  Future<void> _onSearchLocation(
    SearchLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final location = await getCoordinatesFromAddress(event.query);
      _pendingLocation = location;
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
