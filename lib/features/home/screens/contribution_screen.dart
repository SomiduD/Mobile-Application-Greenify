import 'package:flutter/material.dart';
import 'leaderboard_screen.dart';

class ContributionScreen extends StatelessWidget {
  const ContributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('My Contributions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 1. The Impact Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.teal.shade400, Colors.teal.shade700]), borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                const Icon(Icons.park, size: 60, color: Colors.white),
                const SizedBox(height: 16),
                const Text('You have saved', style: TextStyle(color: Colors.white70)),
                const Text('14 Trees', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('By recycling 45kg of paper and plastic this year.', style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // ADDED: The Leaderboard Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LeaderboardScreen())),
            icon: const Icon(Icons.leaderboard, color: Colors.white),
            label: const Text('View Contribution Leaderboard', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          
          const SizedBox(height: 32),
          const Text('Donate Points to Causes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildCauseCard('Clean the Coastline', 'Help fund beach cleanups in Colombo.', 500, 'Donate 500 Pts'),
          _buildCauseCard('Plant a Sapling', 'Sponsor a tree in the Sinharaja Forest.', 1000, 'Donate 1000 Pts'),
        ],
      ),
    );
  }

  Widget _buildCauseCard(String title, String desc, int points, String btnText) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.teal.shade50, shape: BoxShape.circle), child: const Icon(Icons.volunteer_activism, color: Colors.teal)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(100, 30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      // Currently just a dummy button, but looks great for the UI!
                    },
                    child: Text(btnText, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}