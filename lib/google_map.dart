import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapFlutter extends StatefulWidget {
  final double latitude;
  final double longitude;

  const GoogleMapFlutter({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    // সাইন ইন করা ব্যবহারকারীর লোকেশন থেকে একটি মার্কার তৈরি করা
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: const InfoWindow(title: 'User Location'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('User Location'),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        markers: markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}
