import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'pickup_form_screen.dart';

class SmartScannerScreen extends StatefulWidget {
  const SmartScannerScreen({super.key});

  @override
  State<SmartScannerScreen> createState() => _SmartScannerScreenState();
}

class _SmartScannerScreenState extends State<SmartScannerScreen> {
  File? _imageFile;
  bool _isScanning = false;
  String _detectedMaterial = "Awaiting Scan...";
  int _estimatedPoints = 0;
  List<ImageLabel> _debugLabels = []; // To show the raw AI data

  // The AI Brain
  late ImageLabeler _imageLabeler;

  @override
  void initState() {
    super.initState();
    // Initialize the AI with a 60% confidence threshold
    final options = ImageLabelerOptions(confidenceThreshold: 0.6);
    _imageLabeler = ImageLabeler(options: options);
  }

  @override
  void dispose() {
    _imageLabeler.close(); // Clean up memory when leaving the screen
    super.dispose();
  }

  Future<void> _captureAndAnalyze() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
      _isScanning = true;
    });

    try {
      // 1. Convert photo into an AI-readable format
      final inputImage = InputImage.fromFile(_imageFile!);
      
      // 2. Ask the AI what it sees
      final List<ImageLabel> labels = await _imageLabeler.processImage(inputImage);
      
      // 3. Logic to determine points based on AI labels
      String material = "Unknown Material";
      int points = 10; // Base points

      for (ImageLabel label in labels) {
        final text = label.label.toLowerCase();
        
        if (text.contains('plastic') || text.contains('bottle')) {
          material = "Plastic / PET";
          points = 50;
          break;
        } else if (text.contains('electronics') || text.contains('computer') || text.contains('phone')) {
          material = "E-Waste";
          points = 200;
          break;
        } else if (text.contains('glass') || text.contains('cup')) {
          material = "Glass";
          points = 40;
          break;
        } else if (text.contains('paper') || text.contains('cardboard') || text.contains('box')) {
          material = "Paper / Cardboard";
          points = 30;
          break;
        } else if (text.contains('metal') || text.contains('can')) {
          material = "Metal / Aluminum";
          points = 60;
          break;
        }
      }

      setState(() {
        _detectedMaterial = material;
        _estimatedPoints = points;
        _debugLabels = labels;
        _isScanning = false;
      });

    } catch (e) {
      setState(() {
        _detectedMaterial = "Scan Failed";
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('AI Smart Scanner', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // The Scanner Window
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green, width: 3)),
              child: _imageFile != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(17), child: Image.file(_imageFile!, fit: BoxFit.cover))
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.document_scanner, size: 80, color: Colors.green),
                        SizedBox(height: 16),
                        Text('Point camera at recyclables', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            
            // Big Camera Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: _isScanning ? null : _captureAndAnalyze,
              icon: _isScanning ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.camera_alt, color: Colors.white),
              label: Text(_isScanning ? 'Analyzing via AI...' : 'Tap to Scan Item', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),

            // AI Results Card
            if (_imageFile != null && !_isScanning)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    const Text('AI Analysis Complete', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    const Divider(height: 24),
                    Text(_detectedMaterial, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.stars, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text('Estimated Value: $_estimatedPoints Points', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, minimumSize: const Size(double.infinity, 45), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        // Takes them to the pickup form, theoretically passing the data along!
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PickupFormScreen()));
                      },
                      child: const Text('Schedule Pickup for this Item', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),

            // Optional: Show the raw AI brain data to impress professors
            if (_debugLabels.isNotEmpty && !_isScanning) ...[
              const SizedBox(height: 24),
              const Text('Raw AI Confidence Data:', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _debugLabels.take(4).map((label) {
                  return Chip(
                    label: Text('${label.label} ${(label.confidence * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 10)),
                    backgroundColor: Colors.grey.shade200,
                  );
                }).toList(),
              )
            ]
          ],
        ),
      ),
    );
  }
}