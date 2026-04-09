import 'package:flutter/material.dart';

class PickupHistoryScreen extends StatelessWidget {
  const PickupHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('My Pickup Requests', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHistoryCard('Plastics & E-Waste', 'Pending', 'Scheduled for Tomorrow, 10:00 AM', Colors.orange),
          _buildHistoryCard('Mixed Recyclables', 'Completed', 'Picked up on Oct 12, 2025', Colors.green),
          _buildHistoryCard('Glass Bottles', 'Completed', 'Picked up on Sep 28, 2025', Colors.green),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String title, String status, String date, Color statusColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle), child: const Icon(Icons.recycling, color: Colors.green)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12))),
            ],
          ),
        ),
      ),
    );
  }
}