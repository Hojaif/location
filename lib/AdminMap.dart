import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class AdminMap extends StatefulWidget {
  const AdminMap({super.key});

  @override
  State<AdminMap> createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    fetchUserLocations();
  }

  void fetchUserLocations() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('locations').get();

    for (var doc in snapshot.docs) {
      String name = doc['name'] ?? 'No Name';
      double latitude = doc['latitude'];
      double longitude = doc['longitude'];

      String locationName = await getLocationName(latitude, longitude);

      markers.add(
        Marker(
          markerId: MarkerId(doc.id),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(latitude, longitude),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2, color: Colors.pink),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "AS PAY BD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        locationName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              LatLng(latitude, longitude),
            );
          },
        ),
      );
    }

    setState(() {});
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.locality}, ${place.country}";
      }
    } catch (e) {
      print(e);
    }
    return "Unknown Location";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(28.2096, 83.9856),
                zoom: 7,
              ),
              markers: markers,
              onTap: (argument) {
                _customInfoWindowController.hideInfoWindow!();
              },
              onCameraMove: (position) {
                _customInfoWindowController.onCameraMove!();
              },
              onMapCreated: (GoogleMapController controller) {
                _customInfoWindowController.googleMapController = controller;
              },
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 171,
              width: 250,
              offset: 35,
            ),
          ],
        ),
      ),
    );
  }
}
