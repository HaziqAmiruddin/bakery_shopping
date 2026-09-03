// address_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/profile/domain/address_entities.dart';
import 'package:shopping_app/features/profile/domain/address_usecase.dart';
import 'package:shopping_app/features/profile/presentation/bloc/address_event.dart';
import 'package:shopping_app/features/profile/presentation/bloc/address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final WatchAddressesUseCase watchAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;

  AddressBloc({
    required this.watchAddressesUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.setDefaultAddressUseCase,
  }) : super(AddressLoading()) {
    on<WatchAddressesStarted>(_onWatchStarted);
    on<AddressAdded>(_onAdded);
    on<AddressUpdated>(_onUpdated);
    on<AddressDeleted>(_onDeleted);
    on<AddressSetDefault>(_onSetDefault);
  }

  Future<void> _onWatchStarted(
    WatchAddressesStarted event,
    Emitter<AddressState> emit,
  ) async {
    await emit.forEach<List<Address>>(
      watchAddressesUseCase(),
      onData: (addresses) => AddressLoaded(addresses),
      onError: (error, stackTrace) => AddressError(error.toString()),
    );
  }

  Future<void> _onAdded(AddressAdded event, Emitter<AddressState> emit) async {
    await addAddressUseCase(event.address);
  }

  Future<void> _onUpdated(
    AddressUpdated event,
    Emitter<AddressState> emit,
  ) async {
    await updateAddressUseCase(event.address);
  }

  Future<void> _onDeleted(
    AddressDeleted event,
    Emitter<AddressState> emit,
  ) async {
    await deleteAddressUseCase(event.addressId);
  }

  Future<void> _onSetDefault(
    AddressSetDefault event,
    Emitter<AddressState> emit,
  ) async {
    await setDefaultAddressUseCase(event.addressId);
  }
}
