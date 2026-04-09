import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportGarbageScreen extends StatefulWidget {
  const ReportGarbageScreen({super.key});

  @override
  State<ReportGarbageScreen> createState() => _ReportGarbageScreenState();
}

class _ReportGarbageScreenState extends State<ReportGarbageScreen> {
  final _descController = TextEditingController();
  LatLng? _selectedLocation;
  bool _isLoading = false;

  Future<void> _submitReport() async {
    if (_selectedLocation == null || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a description and tap the map to set a location!'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      // Save the report to the live Admin Requests tab!
      await FirebaseFirestore.instance.collection('pickups').add({
        'type': 'Report', // Tags it as a red Trash Report for the admin
        'material': 'Illegal Dumping',
        'address': _descController.text.trim(),
        'userName': user?.email ?? 'Anonymous User',
        'lat': _selectedLocation!.latitude,
        'lng': _selectedLocation!.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Garbage reported successfully. Thank you for keeping Sri Lanka clean!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Illegal Garbage', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Help us locate and clean up illegal dumping sites.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description / Landmark nearby', alignLabelWithHint: true, border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            
            const Text('Tap the Map to drop a Red Pin:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            
            // The Live Interactive Map
            Container(
              height: 300,
              decoration: BoxDecoration(border: Border.all(color: Colors.redAccent, width: 2), borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(6.9271, 79.8612), zoom: 12), // Default Colombo
                  
                  // THE FIX: Turned this off so the map doesn't crash waiting for GPS permissions!
                  myLocationEnabled: false, 
                  
                  onTap: (LatLng position) {
                    setState(() { _selectedLocation = position; });
                  },
                  markers: _selectedLocation == null ? {} : {
                    Marker(markerId: const MarkerId('garbage_location'), position: _selectedLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed))
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: _isLoading ? null : _submitReport,
                icon: _isLoading ? const SizedBox.shrink() : const Icon(Icons.report_problem, color: Colors.white),
                label: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Report to Admin', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}