// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:carive/providers/location_selection_provider.dart';
import 'package:carive/shared/circular_progress_indicator.dart';
import 'package:carive/shared/constants.dart';
import 'package:carive/shared/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({Key? key, this.onLocationSelected})
      : super(key: key);
  final Function(LatLng)? onLocationSelected;

  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  late GoogleMapController googleMapController;

  @override
  void initState() {
    context.read<LocationSelectionProvider>().address = "Choose Location";
    context.read<LocationSelectionProvider>().markers = {};
    context.read<LocationSelectionProvider>().selectedLatLng = null;
    context.read<LocationSelectionProvider>().isCurrentLocationSelected = false;
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(10.850516, 76.271080), zoom: 8);

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void onMapTap(LatLng latLng) {
    getAddress(latLng);
    context.read<LocationSelectionProvider>().setMarkerEmpty();
    context.read<LocationSelectionProvider>().setLatLng(latLng);
    context.read<LocationSelectionProvider>().setCurrentLocationFalse();
    context.read<LocationSelectionProvider>().addMarkers(latLng);
  }
  getAddress(LatLng latLong) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(latLong.latitude, latLong.longitude);
    context.read<LocationSelectionProvider>().setAddress(
        "${placemark[0].subLocality!} ${placemark[0].locality!} ${placemark[0].country!}");
  }

  Future<LatLng> getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  void onCurrentLocationIconPressed() async {
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CustomProgressIndicator(),
        ),
      );

      LatLng currentLocation = await getCurrentLocation();
      Navigator.of(context).pop();

      getAddress(currentLocation);
      context.read<LocationSelectionProvider>().setMarkerEmpty();
      context.read<LocationSelectionProvider>().setLatLng(currentLocation);
      context.read<LocationSelectionProvider>().addMarkers(currentLocation);
      context.read<LocationSelectionProvider>().setCurrentLocationTrue();

      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(
            currentLocation, 15), 
      );
    } else if (permissionStatus.isDenied ||
        permissionStatus.isPermanentlyDenied) {
      showPermissionAlertDialog('Permission Denied',
          'Location permission has been denied by the user.');
    } else if (permissionStatus.isRestricted) {
      showPermissionAlertDialog(
          'Permission Restricted', 'Location permission is restricted.');
    }
  }

  

  void onCheckIconPressed() {
    if (context.read<LocationSelectionProvider>().selectedLatLng != null) {
      LatLng selectedLocation =
          context.read<LocationSelectionProvider>().selectedLatLng!;
      widget.onLocationSelected?.call(selectedLocation);
    }
  }

  void showPermissionAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeColorGrey,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            content,
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColorGrey,
        actions: [
          TextButton(
              onPressed: onCheckIconPressed,
              child: const Text(
                "Done",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: onMapCreated,
            onTap: onMapTap,
            markers: context.watch<LocationSelectionProvider>().markers!,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: CustomElevatedButton(
                  text: context.watch<LocationSelectionProvider>().address!,
                  onPressed: () {},
                  paddingHorizontal: 3,
                  paddingVertical: 3,
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColorGrey,
        foregroundColor: Colors.white,
        onPressed: onCurrentLocationIconPressed,
        heroTag: 'current_location',
        tooltip: "Current Location",
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
