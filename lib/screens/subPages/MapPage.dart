import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;
  Set<Marker> _markers = {Marker(markerId: MarkerId("1"), position: LatLng(45.521563, -122.677433))};
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          TextButton.icon(
            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              setState(() {
                _currentMapType = _currentMapType == MapType.normal
                  ? MapType.satellite
                  : MapType.normal;
              });
            },
            icon: Icon(Icons.map_rounded),
            label: Text(_currentMapType == MapType.normal ? 'Map View' : 'Satellite View'))
        ],
      ),
      body: GoogleMap(
        mapType: _currentMapType,
        onMapCreated: _onMapCreated,
        markers: _markers,
        onCameraMove: _onCameraMove,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
