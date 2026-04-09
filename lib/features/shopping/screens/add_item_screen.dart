import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedCategory = 'Electronics';
  final List<String> _categories = ['Electronics', 'Furniture', 'Clothing', 'Books', 'Other'];
  
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    // Highly compressed so it fits in the free Firestore database
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20, maxWidth: 600);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _postItem() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add an image, title, and price!')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final sellerName = userDoc.data()?['username'] ?? 'Anonymous Seller';

      // Convert image to text string
      final bytes = await _imageFile!.readAsBytes();
      final imageBase64 = base64Encode(bytes);

      // Save to marketplace collection
      await FirebaseFirestore.instance.collection('marketplace').add({
        'sellerId': user.uid,
        'sellerName': sellerName,
        'title': _titleController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'description': _descController.text.trim(),
        'location': _locationController.text.trim(),
        'category': _selectedCategory,
        'imageBase64': imageBase64,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item posted successfully!'), backgroundColor: Colors.green));
        Navigator.pop(context);
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Sell an Item', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker Box
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200, width: double.infinity,
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green.shade200, width: 2, style: BorderStyle.solid)),
                child: _imageFile != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(13), child: Image.file(_imageFile!, fit: BoxFit.cover))
                    : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo, size: 50, color: Colors.green), SizedBox(height: 8), Text('Tap to add photo', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))]),
              ),
            ),
            const SizedBox(height: 24),
            
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Item Title', border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Price (Rs)', prefixText: 'Rs ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))))),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(controller: _locationController, decoration: InputDecoration(labelText: 'Location (City)', prefixIcon: const Icon(Icons.location_on), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 16),
            TextField(controller: _descController, maxLines: 3, decoration: InputDecoration(labelText: 'Description (Condition, age, etc.)', alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: _isLoading ? null : _postItem,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Post Item', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}