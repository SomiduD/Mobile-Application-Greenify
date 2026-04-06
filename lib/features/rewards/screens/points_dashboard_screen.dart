import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'rewards_catalog_screen.dart';

class PointsDashboardScreen extends StatelessWidget {
  const PointsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Points Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/pattern.png'), // Add a subtle pattern later if you want
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Points', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.recycling, color: Colors.white, size: 40),
                      SizedBox(width: 16),
                      Text('You earned\n470 Points', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text('USER #123454', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Top Users Leaderboard
            const Text('Top users this week', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildLeaderboardItem('Liam Benjamin', '740 points', 'https://i.pravatar.cc/150?img=11'),
                  const Divider(height: 1),
                  _buildLeaderboardItem('Olivia Charlotte', '700 points', 'https://i.pravatar.cc/150?img=5'),
                  const Divider(height: 1),
                  _buildLeaderboardItem('Amelia Isabella', '687 points', 'https://i.pravatar.cc/150?img=9'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Go to Rewards Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RewardsCatalogScreen()),
                  );
                },
                child: const Text('Go to Rewards'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(String name, String points, String avatarUrl) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(
        points,
        style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}