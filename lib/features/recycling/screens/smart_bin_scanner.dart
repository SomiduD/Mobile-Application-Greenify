import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SmartBinScannerScreen extends StatefulWidget {
  const SmartBinScannerScreen({super.key});

  @override
  State<SmartBinScannerScreen> createState() => _SmartBinScannerScreenState();
}

class _SmartBinScannerScreenState extends State<SmartBinScannerScreen> {
  bool _isProcessing = false;

  Future<void> _processQRCode(String? code) async {
    if (code == null || _isProcessing) return;
    setState(() => _isProcessing = true);

    // Security check: Make sure it's an actual Greenify Bin, not a random website link!
    if (code.startsWith("GREENIFY_BIN_")) {
      try {
        final user = FirebaseAuth.instance.currentUser!;
        
        // Add 10 points to the user's account instantly
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'points': FieldValue.increment(10)
        });

        if (mounted) {
          _showSuccessDialog();
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error. Try again.')));
        setState(() => _isProcessing = false);
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid QR Code. Please scan a Greenify Bin.'), backgroundColor: Colors.red));
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isProcessing = false);
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text('Bin Unlocked!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('You earned 10 Green Points.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 45)),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to dashboard
              },
              child: const Text('Awesome!', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                _processQRCode(barcode.rawValue);
              }
            },
          ),
          // HUD Overlay
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                      const Text('Scan Smart Bin', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  Container(height: 250, width: 250, decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 4), borderRadius: BorderRadius.circular(20))),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Center the QR code on the Smart Bin inside the square.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  if (_isProcessing) const LinearProgressIndicator(color: Colors.green),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}