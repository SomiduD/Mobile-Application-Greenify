import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'pickup_form_screen.dart';

class LiveAIScannerScreen extends StatefulWidget {
  const LiveAIScannerScreen({super.key});

  @override
  State<LiveAIScannerScreen> createState() => _LiveAIScannerScreenState();
}

class _LiveAIScannerScreenState extends State<LiveAIScannerScreen> {
  CameraController? _cameraController;
  late ImageLabeler _imageLabeler;
  Timer? _aiTimer;
  
  String _detectedMaterial = "Scanning...";
  int _estimatedPoints = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.6));
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.medium, enableAudio: false);
    await _cameraController!.initialize();
    
    if (mounted) setState(() {});

    // This is the "Heartbeat" of the AI. It takes a silent photo every 1.5 seconds and analyzes it.
    _aiTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      _analyzeCurrentFrame();
    });
  }

  Future<void> _analyzeCurrentFrame() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) return;
    
    _isProcessing = true;
    try {
      final picture = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(picture.path);
      final labels = await _imageLabeler.processImage(inputImage);

      String material = "Keep pointing...";
      int points = 0;

      for (ImageLabel label in labels) {
        final text = label.label.toLowerCase();
        if (text.contains('plastic') || text.contains('bottle')) { material = "Plastic Bottle"; points = 50; break; } 
        else if (text.contains('electronics') || text.contains('keyboard')) { material = "E-Waste"; points = 200; break; } 
        else if (text.contains('glass')) { material = "Glass"; points = 40; break; } 
        else if (text.contains('paper') || text.contains('box')) { material = "Cardboard / Paper"; points = 30; break; }
      }

      if (mounted) {
        setState(() {
          _detectedMaterial = material;
          _estimatedPoints = points;
        });
      }
    } catch (e) {
      // Ignore errors from moving the camera too fast
    } finally {
      _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _aiTimer?.cancel();
    _cameraController?.dispose();
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.green)));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. The Live Camera Feed
          CameraPreview(_cameraController!),
          
          // 2. The AR Scanner Overlay (Cool visual effect)
          Center(
            child: Container(
              height: 250, width: 250,
              decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent, width: 2), borderRadius: BorderRadius.circular(20)),
              child: const Center(child: Icon(Icons.document_scanner, color: Colors.greenAccent, size: 50)),
            ),
          ),

          // 3. The Live Data HUD
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_detectedMaterial, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _estimatedPoints > 0 ? Colors.green : Colors.black87)),
                  const SizedBox(height: 8),
                  Text(_estimatedPoints > 0 ? 'Value: $_estimatedPoints Points' : 'Looking for recyclables...', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: _estimatedPoints == 0 ? null : () {
                      _aiTimer?.cancel(); // Stop AI before leaving
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PickupFormScreen()));
                    },
                    child: const Text('Schedule Pickup', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          
          // Back Button
          Positioned(top: 50, left: 16, child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30), onPressed: () => Navigator.pop(context))),
        ],
      ),
    );
  }
}