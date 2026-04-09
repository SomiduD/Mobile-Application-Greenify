import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _nameController = TextEditingController();
  final _truckController = TextEditingController();
  
  LatLng? _selectedLocation;
  bool _isOnline = true;
  bool _isLoading = false;

  Future<void> _saveDriver() async {
    if (_nameController.text.isEmpty || _truckController.text.isEmpty || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and tap the map to set a location!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save the driver to the real Firebase database!
      await FirebaseFirestore.instance.collection('drivers').add({
        'name': _nameController.text.trim(),
        'truck': _truckController.text.trim(),
        'lat': _selectedLocation!.latitude,
        'lng': _selectedLocation!.longitude,
        'status': _isOnline ? 'Active' : 'Offline',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Driver Registered Successfully!'), backgroundColor: Colors.green));
        Navigator.pop(context); // Go back to dashboard
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
      appBar: AppBar(title: const Text('Register New Driver'), backgroundColor: Colors.black87, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Driver Name', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _truckController, decoration: const InputDecoration(labelText: 'Truck Number Plate', prefixIcon: Icon(Icons.local_shipping), border: OutlineInputBorder())),
            const SizedBox(height: 24),
            
            // The Online/Offline Toggle
            Container(
              decoration: BoxDecoration(color: _isOnline ? Colors.green.shade50 : Colors.grey.shade200, borderRadius: BorderRadius.circular(15), border: Border.all(color: _isOnline ? Colors.green : Colors.grey)),
              child: SwitchListTile(
                title: Text(_isOnline ? 'Driver is Online & Active' : 'Driver is Offline', style: TextStyle(fontWeight: FontWeight.bold, color: _isOnline ? Colors.green : Colors.grey)),
                value: _isOnline,
                activeColor: Colors.green,
                onChanged: (val) => setState(() => _isOnline = val),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Tap Map to Set Base Location:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            
            // The Interactive Map Picker
            Container(
              height: 250,
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2), borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(6.9271, 79.8612), zoom: 10), // Default Colombo
                  onTap: (LatLng position) {
                    setState(() { _selectedLocation = position; });
                  },
                  markers: _selectedLocation == null ? {} : {
                    Marker(markerId: const MarkerId('driver_base'), position: _selectedLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen))
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: _isLoading ? null : _saveDriver,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Driver to Database', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}