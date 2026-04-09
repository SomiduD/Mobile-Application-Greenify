import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedType = 'Center'; // 'Center' or 'Bin'
  LatLng? _selectedLocation;
  bool _isLoading = false;

  Future<void> _saveLocation() async {
    if (_titleController.text.isEmpty || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add a title and tap the map!')));
      return;
    }
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance.collection('locations').add({
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'type': _selectedType,
      'lat': _selectedLocation!.latitude,
      'lng': _selectedLocation!.longitude,
    });
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location added successfully!'), backgroundColor: Colors.green));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Map Marker'), backgroundColor: Colors.black87, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: ['Center', 'Bin'].map((String type) => DropdownMenuItem(value: type, child: Text(type == 'Center' ? 'Recycling Center (Green)' : 'Smart Bin (Orange)'))).toList(),
              onChanged: (val) => setState(() => _selectedType = val!),
              decoration: const InputDecoration(labelText: 'Location Type', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title (e.g., Main NSBM Bin)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            const Text('Tap Map to Drop Pin:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 250,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(6.9271, 79.8612), zoom: 10),
                  onTap: (LatLng pos) => setState(() => _selectedLocation = pos),
                  markers: _selectedLocation == null ? {} : { Marker(markerId: const MarkerId('new'), position: _selectedLocation!) },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
              onPressed: _isLoading ? null : _saveLocation,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save to Live Map', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}