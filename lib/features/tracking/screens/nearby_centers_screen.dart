import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NearbyCentersScreen extends StatelessWidget {
  const NearbyCentersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Centers', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by city (e.g., Colombo, Malabe)',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          
          const Text('Closest to you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          _buildCenterCard('Western Province Main Hub', 'Colombo 07', '2.5 km', true),
          _buildCenterCard('Malabe E-Waste Center', 'Kaduwela Road, Malabe', '5.1 km', true),
          _buildCenterCard('Gampaha Plastic Recycle', 'Main Street, Gampaha', '12.4 km', false),
          _buildCenterCard('Kalutara Paper Plant', 'Galle Road, Kalutara', '34.2 km', true),
        ],
      ),
    );
  }

  Widget _buildCenterCard(String name, String address, String distance, bool isOpen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.location_city, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(address, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.directions_walk, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(distance, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(width: 12),
                    Text(isOpen ? '• Open Now' : '• Closed', style: TextStyle(color: isOpen ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}