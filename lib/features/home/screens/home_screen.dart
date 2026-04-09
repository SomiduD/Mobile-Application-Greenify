import 'dart:convert'; // NEW: For decoding the Base64 image
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../shopping/screens/marketplace_screen.dart';
import '../../tracking/screens/truck_tracker_screen.dart';
import '../../special_requests/screens/report_garbage_screen.dart';
import '../../recycling/screens/pickup_form_screen.dart';
import '../../recycling/screens/smart_scanner_screen.dart';
import '../../recycling/screens/live_ai_scanner.dart';
import '../../recycling/screens/smart_bin_scanner.dart';
import '../../maps/screens/nearby_screen.dart';
import '../../home/screens/contribution_screen.dart'; // Adjust path based on where you saved it! // Adjust path based on where you saved it!

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data() as Map<String, dynamic>?;
                  final name = data?['username'] ?? 'User';
                  final points = data?['points'] ?? 0;
                  final base64Image = data?['profileImageBase64']; // Get the image

                  // Extract initials
                  String initials = "U";
                  if (name.isNotEmpty) {
                    List<String> nameParts = name.split(" ");
                    initials = nameParts.length > 1 
                        ? nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase() 
                        : nameParts[0][0].toUpperCase();
                  }

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Good afternoon!', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Text(name, style: const TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          // Decoded Avatar
                          CircleAvatar(
                            radius: 24, 
                            backgroundColor: Colors.green,
                            backgroundImage: (base64Image != null && base64Image.isNotEmpty) 
                                ? MemoryImage(base64Decode(base64Image)) 
                                : null,
                            child: (base64Image == null || base64Image.isEmpty) 
                                ? Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Total Impact Card (Now updating live!)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade900]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Impact', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                const SizedBox(height: 8),
                                Text('$points Points', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withAlpha(50), shape: BoxShape.circle), child: const Icon(Icons.eco, color: Colors.white, size: 32)),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              ),
              const SizedBox(height: 32),

              const Text('Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // Services Grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 24,
                crossAxisSpacing: 16,
                children: [
                  _buildServiceIcon(context, Icons.recycling, 'Recycle', Colors.green, const PickupFormScreen()), 
                  _buildServiceIcon(context, Icons.location_on, 'Nearby', Colors.red, const NearbyScreen()),
                  InkWell(
                    onTap: () {
                      try {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TruckTrackerScreen()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maps configuration required.')));
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.blueGrey.withAlpha(30), shape: BoxShape.circle), child: const Icon(Icons.local_shipping, color: Colors.blueGrey, size: 28)),
                        const SizedBox(height: 8),
                        const Text('Nearby Trucks', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  _buildServiceIcon(context, Icons.shopping_bag, 'Shopping', Colors.purple, const MarketplaceScreen()),
                  _buildServiceIcon(context, Icons.report_problem, 'Report Trash', Colors.redAccent, const ReportGarbageScreen()),
                  _buildServiceIcon(context, Icons.eco, 'My Impact', Colors.green, const ContributionScreen()),
                  _buildServiceIcon(context, Icons.document_scanner, 'AI Scanner', Colors.blue, const SmartScannerScreen()),
                  // The AI Scanner
                  _buildServiceIcon(context, Icons.document_scanner, 'AI Scanner', Colors.blue, const LiveAIScannerScreen()), 
                  _buildServiceIcon(context, Icons.qr_code_scanner, 'Smart Bin', Colors.orange, const SmartBinScannerScreen()),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context, IconData icon, String label, Color color, Widget? targetScreen) {
    return InkWell(
      onTap: () {
        if (targetScreen != null) Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withAlpha(30), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}