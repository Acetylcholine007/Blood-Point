import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/screens/subPages/ProfileViewer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class DonorMap extends StatefulWidget {
  final List<AccountData> accounts;
  final AccountData myAccount;

  const DonorMap(this.accounts, this.myAccount, {Key key}) : super(key: key);

  @override
  State<DonorMap> createState() => _DonorMapState();
}

class _DonorMapState extends State<DonorMap> {
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  LatLng _target = LatLng(45.521563, -122.677433);

  LatLng calculateCenter (List<LatLng> coordinates) {
    if(coordinates.length == 1) {
      return coordinates[0];
    }

    double x = 0;
    double y = 0;
    double z = 0;

    coordinates.forEach((coordinate) {
      double latitude = coordinate.latitude * math.pi * 180;
      double longitude = coordinate.longitude * math.pi * 180;

      x += math.cos(latitude) * math.cos(longitude);
      y += math.cos(latitude) * math.sin(longitude);
      z += math.sin(latitude);
    });

    x /= coordinates.length;
    y /= coordinates.length;
    z /= coordinates.length;

    double centralLng = math.atan2(y, x);
    double centralSquareRoot = math.sqrt(x * x + y * y);
    double centralLat = math.atan2(z, centralSquareRoot);

    return LatLng(centralLat * 180 / math.pi, centralLng * 180 / math.pi);
  }

  void initState() {
    setState(() {
      // _target = calculateCenter(widget.accounts.map((account) => LatLng(account.latitude, account.longitude)).toList());
      _target = LatLng(14.8434897, 120.8112473);
      _markers = widget.accounts.map((account) => Marker(
        markerId: MarkerId(account.uid),
        position: LatLng(account.latitude, account.longitude),
        infoWindow: InfoWindow(
          title: account.fullName,
          snippet: '${account.bloodType} blood type',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileViewer(account, widget.myAccount)))
        ),
      )).toSet();
    });
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: EdgeInsets.all(0),
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      markers: _markers,
      initialCameraPosition: CameraPosition(
        target: _target,
        zoom: 11.0,
      ),
    );
  }
}
