import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_constant.dart';
import 'package:asisten_buku_kebun/presenter/crop_map_presenter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CropMapScreen extends StatefulWidget {
  CropMapScreen({super.key});

  CropMapPresenter cropMapPresenter = DI.cropMapPresenter;

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

  LatLng? _currentPosition;

  _getLocation() async {
    await Permission.locationWhenInUse.request();
    if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
      return;
    }
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition();
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _markers.add(
        Marker(
          markerId: const MarkerId('You'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    });
  }

  @override
  initState() {
    super.initState();
    _getLocation();
    // _getCrops();
  }

  Future<void> _getCrops() async {
    try {
      await widget.cropMapPresenter.fetchAllCrop();
      if (!mounted) return;
      if (widget.cropMapPresenter.requestState == RequestState.success) {
        setState(() {
          for (var crop in widget.cropMapPresenter.allCrops) {
            if (crop.locationLat == null || crop.locationLon == null) {
              continue;
            } else {
              _markers.add(
                Marker(
                  markerId: MarkerId(crop.cropId.toString()),
                  position: LatLng(crop.locationLat!, crop.locationLon!),
                  draggable: false,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    // You can customize the marker color based on crop status
                    crop.cropStatus == AppConstant.CROP_SEHAT
                        ? BitmapDescriptor.hueGreen
                        : crop.cropStatus == AppConstant.CROP_SAKIT
                        ? BitmapDescriptor.hueYellow
                        : crop.cropStatus == AppConstant.CROP_MATI
                        ? BitmapDescriptor.hueRed
                        : BitmapDescriptor.hueOrange,
                  ),
                  infoWindow: InfoWindow(
                    title: crop.cropName,
                    snippet:
                        "${crop.type} by ${crop.user?.name} (${crop.cropStatus})",
                  ),
                ),
              );
            }
          }
        });
      } else {
        // Show error message
        showAppToast(
          context,
          widget.cropMapPresenter.message,
          title: "Terjadi Kesalahan",
        );
      }
    } catch (e) {
      // Handle errors here
      showAppToast(
        context,
        'Terjadi kesalahan: $e. Silakan coba lagi',
        title: 'Error Tidak Terduga 😢',
      );
    }
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crops Map')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _currentPosition ?? LatLng(-6.200000, 106.816666),
          zoom: 12,
        ),
        // mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
