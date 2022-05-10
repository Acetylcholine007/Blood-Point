import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;

  const MapPage(this.origin, this.destination, {Key key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;
  Set<Marker> _markers;
  LatLng _center;
  LatLng _lastMapPosition;

  @override
  void initState() {
    _markers = {
      Marker(markerId: MarkerId("origin"), position: widget.origin, infoWindow: InfoWindow(title: 'Your Location')),
      Marker(markerId: MarkerId("destination"), position: widget.destination, infoWindow: InfoWindow(title: 'Target Location'))
    };
    _center = widget.origin;
    _lastMapPosition = widget.origin;
    super.initState();
  }

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
