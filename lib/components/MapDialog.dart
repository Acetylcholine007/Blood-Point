import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDialog extends StatefulWidget {
  const MapDialog({Key key}) : super(key: key);

  @override
  State<MapDialog> createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  final LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng _lastMapPosition = LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      markers: _markers,
      onCameraMove: _onCameraMove,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    );
  }
}
