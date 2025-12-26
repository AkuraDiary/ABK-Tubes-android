import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CropMapScreen extends StatefulWidget {
  const CropMapScreen({super.key});

  @override
  State<CropMapScreen> createState() => _CropMapScreenState();
}

class _CropMapScreenState extends State<CropMapScreen> {
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  late LatLng _currentPosition;

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition();
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
    });
  }

  @override
  Future<void> initState() async {
    super.initState();
    await Permission.locationWhenInUse.request();
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      getLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Demo')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: {
          Marker(
            markerId: const MarkerId('You'),
            position: _currentPosition,
            infoWindow: const InfoWindow(title: 'You are here'),
          ),
        },
        initialCameraPosition: CameraPosition(target: _currentPosition),
        // mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
