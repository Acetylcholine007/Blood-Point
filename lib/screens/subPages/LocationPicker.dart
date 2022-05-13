import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final LatLng target;
  final Set<Marker> _markers;
  final Function markerChangeHandler;
  const LocationPicker(this.target, this._markers, this.markerChangeHandler, {Key key}) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  LatLng _target;
  LatLng _lastMapPosition;

  @override
  void initState() {
    setState(() {
      _target = widget.target;
      _lastMapPosition = widget.target;
      _markers = widget._markers;
    });
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onAddMarkerButtonPressed(LatLng latlang) {
    setState(() {
      _target = latlang;
      _markers = {Marker(markerId: MarkerId("location"), position: latlang)};
    });
    widget.markerChangeHandler(latlang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick your Exact Location'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        markers: _markers,
        onCameraMove: _onCameraMove,
        onTap: (latlang){
          if(_markers.length>=1)
          {
            _markers.clear();
          }

          _onAddMarkerButtonPressed(latlang);
        },
        initialCameraPosition: CameraPosition(
          target: _target,
          zoom: 15.0,
        ),
      ),
    );
  }
}
