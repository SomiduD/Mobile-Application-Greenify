import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  // Centered around Colombo / Western Province for the demo
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(6.9271, 79.8612), 
    zoom: 12.0,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    setState(() {
      // Dummy data for Recycling Centers (Green Markers)
      _markers.add(_buildMarker('center_1', 6.9271, 79.8612, 'Colombo Main Recycling Center', 'Accepts all materials', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
      _markers.add(_buildMarker('center_2', 6.8211, 80.0399, 'NSBM Eco Center', 'E-Waste & Plastics', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
      
      // Dummy data for Smart Bins (Orange Markers)
      _markers.add(_buildMarker('bin_1', 6.9350, 79.8500, 'Smart Bin #01', 'Galle Face Green', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)));
      _markers.add(_buildMarker('bin_2', 7.2093, 79.8362, 'Smart Bin #02', 'Negombo Beach Park', BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)));
    });
  }

  Marker _buildMarker(String id, double lat, double lng, String title, String snippet, BitmapDescriptor icon) {
    return Marker(
      markerId: MarkerId(id),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: snippet),
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Drop-offs', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),
          // Legend Overlay
          Positioned(
            top: 16, left: 16, right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [Icon(Icons.location_on, color: Colors.green.shade600), const SizedBox(width: 4), const Text('Recycling Center', style: TextStyle(fontWeight: FontWeight.bold))]),
                  Row(children: [Icon(Icons.location_on, color: Colors.orange.shade600), const SizedBox(width: 4), const Text('Smart Bin', style: TextStyle(fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}