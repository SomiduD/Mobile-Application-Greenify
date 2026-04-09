import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RewardsCatalogScreen extends StatelessWidget {
  const RewardsCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen, // Matches Figure 35 background
      appBar: AppBar(
        backgroundColor: AppColors.lightGreen,
        title: const Text('Collect your rewards', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildRewardCoupon('KFC', '15% OFF', 'users with 500 points or above', Icons.fastfood, Colors.red),
          _buildRewardCoupon('Java Lounge', '2 Free Coffees', 'users with 650 points or above', Icons.local_cafe, Colors.brown),
          _buildRewardCoupon('Greenify', '10% off\nonly electronics', 'users with 660 points or above', Icons.recycling, AppColors.primaryGreen),
          _buildRewardCoupon('McDonalds', 'RS 5000', 'users with 1000 points or above', Icons.lunch_dining, Colors.orange),
          _buildRewardCoupon('Greenify', '100 points = rs.50', 'Convert points to cash', Icons.currency_exchange, AppColors.primaryGreen),
        ],
      ),
    );
  }

  Widget _buildRewardCoupon(String brand, String title, String subtitle, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(brand, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}