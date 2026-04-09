import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Tips & News', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Featured Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildTipCard(
            'How to compost at home',
            'Turn your kitchen waste into nutrient-rich soil for your garden in just 4 easy steps.',
            'https://images.unsplash.com/photo-1590682680695-43b964a3ae17?q=80&w=400&auto=format&fit=crop',
          ),
          _buildTipCard(
            'The truth about E-Waste',
            'Why throwing batteries in the standard bin is dangerous and how to dispose of them properly.',
            'https://images.unsplash.com/photo-1550009158-9effb6197316?q=80&w=400&auto=format&fit=crop',
          ),
          _buildTipCard(
            'Upcycling old clothes',
            'Don\'t throw away ripped jeans! Here are 5 creative ways to turn old clothes into new household items.',
            'https://images.unsplash.com/photo-1605289982774-9a6fef564df8?q=80&w=400&auto=format&fit=crop',
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String description, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
                const SizedBox(height: 12),
                const Text('Read more ->', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}