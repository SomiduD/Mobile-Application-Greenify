import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key});

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final _binIdController = TextEditingController(text: '1');
  String _qrData = 'GREENIFY_BIN_1';

  void _generateQR() {
    setState(() {
      // This MUST match the prefix we set in the SmartBinScannerScreen!
      _qrData = 'GREENIFY_BIN_${_binIdController.text.trim()}';
    });
    FocusScope.of(context).unfocus(); // Close keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Smart Bin QR'), backgroundColor: Colors.black87, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Enter a unique number for this new physical bin.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: _binIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Bin ID Number', border: OutlineInputBorder(), prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
              onPressed: _generateQR,
              child: const Text('Generate QR Code', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 40),
            
            // The Actual QR Code Image
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)]),
              child: Column(
                children: [
                  QrImageView(
                    data: _qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    foregroundColor: Colors.green.shade800,
                  ),
                  const SizedBox(height: 16),
                  Text(_qrData, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text('Screenshot this and print it!', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}