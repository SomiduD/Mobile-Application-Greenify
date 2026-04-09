import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Drop-offs', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('locations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          // Build live markers from Firebase
          Set<Marker> markers = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final isBin = data['type'] == 'Bin';
            
            return Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(data['lat'], data['lng']),
              infoWindow: InfoWindow(title: data['title'], snippet: data['description']),
              icon: BitmapDescriptor.defaultMarkerWithHue(isBin ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueGreen),
            );
          }).toSet();

          return Stack(
            children: [
              GoogleMap(initialCameraPosition: const CameraPosition(target: LatLng(6.9271, 79.8612), zoom: 10.0), markers: markers, myLocationEnabled: true),
              Positioned(
                top: 16, left: 16, right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
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
          );
        },
      ),
    );
  }
}