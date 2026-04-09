import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shopping/screens/chat_screen.dart'; // Reusing your existing chat screen!

class TruckTrackerScreen extends StatefulWidget {
  const TruckTrackerScreen({super.key});

  @override
  State<TruckTrackerScreen> createState() => _TruckTrackerScreenState();
}

class _TruckTrackerScreenState extends State<TruckTrackerScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Future<void> _flyToDriver(double lat, double lng) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 16.0, tilt: 45.0),
    ));
    if (!mounted) return;
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Trucks', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: StreamBuilder<QuerySnapshot>(
        // Fetch ALL drivers from Firebase LIVE!
        stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.green));

          final allDrivers = snapshot.data!.docs;
          
          // Filter drivers based on the search bar
          final filteredDrivers = allDrivers.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = data['name'].toString().toLowerCase();
            return name.contains(_searchQuery.toLowerCase());
          }).toList();

          // Generate map pins for the filtered drivers
          Set<Marker> markers = filteredDrivers.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(data['lat'], data['lng']),
              infoWindow: InfoWindow(title: data['name'], snippet: data['truck']),
              icon: BitmapDescriptor.defaultMarkerWithHue(data['status'] == 'Active' ? BitmapDescriptor.hueBlue : BitmapDescriptor.hueRed),
            );
          }).toSet();

          return Column(
            children: [
              // 1. The Live Map
              Expanded(
                flex: 5,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(6.9271, 79.8612), zoom: 10.0),
                  markers: markers,
                  myLocationEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_mapController.isCompleted) _mapController.complete(controller);
                  },
                ),
              ),
              
              // 2. Search & List
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(hintText: 'Search by driver name...', prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
                        ),
                      ),
                      Expanded(
                        child: filteredDrivers.isEmpty 
                          ? const Center(child: Text('No drivers found.', style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              itemCount: filteredDrivers.length,
                              itemBuilder: (context, index) {
                                final doc = filteredDrivers[index];
                                final driver = doc.data() as Map<String, dynamic>;
                                final isActive = driver['status'] == 'Active';
                                
                                return ListTile(
                                  leading: CircleAvatar(backgroundColor: isActive ? Colors.blue.shade100 : Colors.grey.shade200, child: Icon(Icons.local_shipping, color: isActive ? Colors.blue : Colors.grey)),
                                  title: Text(driver['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text('${driver['truck']} • ${driver['status']}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // CHAT BUTTON
                                      IconButton(
                                        icon: const Icon(Icons.chat, color: Colors.orange),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(sellerId: doc.id, sellerName: driver['name'], itemTitle: 'Pickup Inquiry')));
                                        },
                                      ),
                                      // FLY TO MAP BUTTON
                                      IconButton(
                                        icon: const Icon(Icons.my_location, color: Colors.green),
                                        onPressed: () => _flyToDriver(driver['lat'], driver['lng']),
                                      ),
                                    ],
                                  ),
                                  onTap: () => _flyToDriver(driver['lat'], driver['lng']),
                                );
                              },
                            ),
                      )
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