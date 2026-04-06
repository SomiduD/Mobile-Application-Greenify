import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'pickup_form_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Your Recyclables', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Promotional Banner
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?q=80&w=400&auto=format&fit=crop'), // Placeholder eco image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'GET FAIR VALUE FOR\nYOUR RECYCLABLES',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            const Text('You can recycle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Categories Grid
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              children: [
                _buildCategoryItem(Icons.description, 'Paper'),
                _buildCategoryItem(Icons.local_drink, 'Plastic'),
                _buildCategoryItem(Icons.settings, 'Metal'),
                _buildCategoryItem(Icons.wine_bar, 'Glass'),
                _buildCategoryItem(Icons.shopping_bag, 'Polythene'),
                _buildCategoryItem(Icons.computer, 'E-waste'),
                _buildCategoryItem(Icons.delete, 'Kitchen\nWaste'),
                _buildCategoryItem(Icons.category, 'Other'),
              ],
            ),
            const SizedBox(height: 40),
            
            // Next Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the form screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PickupFormScreen()),
                );
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text("Let's start"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.darkGreen, size: 24),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
      ],
    );
  }
}