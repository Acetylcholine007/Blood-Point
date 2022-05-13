import 'package:blood_point/components/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  _createPolylines(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude,
      ) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyB8WUe83Z229hdernamqUTL-OtOfnBjrhk', // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

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
      body: FutureBuilder(
        future:
        _createPolylines(widget.origin.latitude, widget.origin.longitude, widget.destination.latitude, widget.destination.longitude),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return GoogleMap(
              mapType: _currentMapType,
              onMapCreated: _onMapCreated,
              markers: _markers,
              onCameraMove: _onCameraMove,
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            );
          } else {
            return Loading('Generating Route');
          }
        },
      ),
    );
  }
}
