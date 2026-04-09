import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RequestHistoryScreen extends StatelessWidget {
  const RequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pickup Requests', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHistoryItem('REQ-0042', 'Plastics & Paper', 'April 6, 2026', 'Completed', '+50 Points', Colors.green),
          _buildHistoryItem('REQ-0041', 'E-Waste', 'April 2, 2026', 'Completed', '+120 Points', Colors.green),
          _buildHistoryItem('REQ-0040', 'Mixed Glass', 'March 28, 2026', 'Cancelled', '0 Points', Colors.red),
          _buildHistoryItem('REQ-0039', 'Iron & Metal', 'March 15, 2026', 'Completed', '+80 Points', Colors.green),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String id, String type, String date, String status, String reward, Color statusColor) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.recycling, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 8),
                Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date: $date', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                Text(reward, style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}