import 'dart:io';
import 'dart:convert'; // NEW: For Base64 conversion
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  String? _currentImageBase64; // Changed from URL to Base64 String

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['username'] ?? '';
          _addressController.text = data['address'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _currentImageBase64 = data['profileImageBase64']; // Load the text-image
        });
      }
    }
  }

  Future<void> _pickImage() async {
    // We heavily compress the image so the text string doesn't get too large for Firestore!
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20, maxWidth: 400, maxHeight: 400);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      String? imageString = _currentImageBase64;

      // Convert the physical image file into a Base64 text string
      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        imageString = base64Encode(bytes);
      }

      final Map<String, dynamic> updateData = {
        'username': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      if (imageString != null) updateData['profileImageBase64'] = imageString;

      // Save everything (including the image) directly to the free Firestore database!
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updateData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated!'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving profile: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper method to figure out which image to show
  ImageProvider? _getProfileImage() {
    if (_imageFile != null) return FileImage(_imageFile!);
    if (_currentImageBase64 != null && _currentImageBase64!.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(_currentImageBase64!));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green.shade50,
                    backgroundImage: _getProfileImage(),
                    child: (_imageFile == null && (_currentImageBase64 == null || _currentImageBase64!.isEmpty)) 
                        ? const Icon(Icons.person, size: 60, color: Colors.green) 
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Full Name', prefixIcon: const Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Phone Number', prefixIcon: const Icon(Icons.phone), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            TextField(controller: _addressController, decoration: InputDecoration(labelText: 'Home Address', prefixIcon: const Icon(Icons.home), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}