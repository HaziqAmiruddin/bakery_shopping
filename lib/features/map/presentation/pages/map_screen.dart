import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/map/presentation/bloc/location_bloc.dart';
import 'package:shopping_app/features/map/presentation/bloc/location_event.dart';
import 'package:shopping_app/features/map/presentation/bloc/location_state.dart';

class MapScreen extends StatefulWidget {
  final bool isSelectionMode;
  const MapScreen({super.key, this.isSelectionMode = true});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLatLng;

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(FetchCurrentLocation());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMapTapped(LatLng position) {
    setState(() => _selectedLatLng = position);
    context.read<LocationBloc>().add(
      SelectLocationOnMap(position.latitude, position.longitude),
    );
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    context.read<LocationBloc>().add(SearchLocation(query.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Map', showBackIcon: false),
      padding: EdgeInsets.zero,
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationLoaded) {
            final latLng = LatLng(
              state.location.latitude,
              state.location.longitude,
            );
            setState(() => _selectedLatLng = latLng);
            _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
          }
          if (state is LocationConfirmed) {
            if (widget.isSelectionMode) {
              Navigator.pop(context, state.location);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Location updated')));
            }
          }
          if (state is LocationError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is LocationInitial ||
              state is LocationLoading && state is! LocationLoaded) {
            // still show map once we have any coordinates, spinner only before first fix
          }

          //LatLng? currentLatLng;
          String addressText = 'Fetching location...';
          bool isLoading = state is LocationLoading;

          if (state is LocationLoaded) addressText = state.location.address;
          if (state is LocationError) addressText = 'Unable to fetch location';

          return Stack(
            children: [
              if (_selectedLatLng != null)
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLatLng!,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onTap: _onMapTapped,
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedLatLng!,
                    ),
                  },
                )
              else
                const Center(child: CircularProgressIndicator()),
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _onSearchSubmitted,
                    decoration: InputDecoration(
                      hintText: 'Search location...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _searchController.clear(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).primaryColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        Text(addressText, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: (state is LocationLoaded)
                              ? () => context.read<LocationBloc>().add(
                                  ConfirmSelectedLocation(),
                                )
                              : null,
                          child: const Text('Update Location'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
