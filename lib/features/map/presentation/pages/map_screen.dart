import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/flutter_map_widget.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/map/presentation/widgets/stored_on_map_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Map', showBackIcon: false),
      padding: EdgeInsets.zero,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlutterMapWidget(latLng: LatLng(3.108927, 101.540194)),
          StoresOnMapScreen(),
        ],
      ),
    );
  }
}
