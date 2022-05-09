import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/screens/subPages/ProfileViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DonorMap extends StatefulWidget {
  final List<AccountData> accounts;

  const DonorMap(this.accounts, {Key key}) : super(key: key);

  @override
  State<DonorMap> createState() => _DonorMapState();
}

class _DonorMapState extends State<DonorMap> {
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  LatLng _target = LatLng(45.521563, -122.677433);

  void initState() {
    setState(() {
      _markers = widget.accounts.map((account) => Marker(
        markerId: MarkerId(account.uid),
        position: LatLng(account.latitude, account.longitude),
        infoWindow: InfoWindow(
          title: account.fullName,
          snippet: '${account.bloodType} blood type',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileViewer(account)))
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
