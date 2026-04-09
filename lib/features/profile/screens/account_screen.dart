import 'dart:convert'; // NEW: For decoding the Base64 image
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/routes/app_routes.dart';
import 'edit_profile_screen.dart';
import 'payment_methods_screen.dart';
import 'pickup_history_screen.dart';
import 'settings_screen.dart';
import 'help_support_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final name = data?['username'] ?? 'Eco Warrior';
          final email = user?.email ?? '';
          final points = data?['points'] ?? 0;
          final rank = data?['rank'] ?? 'Silver';
          final base64Image = data?['profileImageBase64']; // Load the text-image!

          // Extract initials for the fallback avatar
          String initials = "U";
          if (name.isNotEmpty && name != 'Eco Warrior') {
            List<String> nameParts = name.split(" ");
            if (nameParts.length > 1) {
              initials = nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
            } else {
              initials = nameParts[0][0].toUpperCase();
            }
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // User Profile Header
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    backgroundImage: (base64Image != null && base64Image.isNotEmpty) 
                        ? MemoryImage(base64Decode(base64Image)) 
                        : null,
                    child: (base64Image == null || base64Image.isEmpty) 
                        ? Text(initials, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)) 
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 4),
                  Text(email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  
                  // Points & Rank Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, spreadRadius: 2)]),
                          child: Column(
                            children: [
                              const Icon(Icons.stars, color: Colors.green, size: 30),
                              const SizedBox(height: 8),
                              Text('$points', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const Text('Total Points', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, spreadRadius: 2)]),
                          child: Column(
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.green, size: 30),
                              const SizedBox(height: 8),
                              Text(rank, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const Text('Current Rank', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              // Menu Items
              _buildListTile(Icons.person_outline, 'Edit Profile', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
              }),
              _buildListTile(Icons.credit_card, 'Payment Methods', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()));
              }),
              _buildListTile(Icons.history, 'My Pickup Requests', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PickupHistoryScreen()));
              }),
              _buildListTile(Icons.settings_outlined, 'Settings', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              }),
              _buildListTile(Icons.help_outline, 'Help & Support', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
              }),
              
              // Logout Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 0,
      color: Colors.green.shade50.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}