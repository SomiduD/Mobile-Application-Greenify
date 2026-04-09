import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Top Contributors', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade600, Colors.teal.shade700]), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30))),
            child: const Column(
              children: [
                Icon(Icons.emoji_events, size: 60, color: Colors.amber),
                SizedBox(height: 8),
                Text('Greenify Hall of Fame', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('The top eco-warriors in Sri Lanka this month!', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // Get top 50 users ordered by points
              stream: FirebaseFirestore.instance.collection('users').orderBy('points', descending: true).limit(50).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.green));
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No contributors yet.'));

                final users = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final isMe = users[index].id == currentUserId;
                    
                    // Determine Rank UI
                    Color rankColor = Colors.grey.shade300;
                    IconData rankIcon = Icons.military_tech;
                    if (index == 0) { rankColor = Colors.amber; rankIcon = Icons.star; }
                    else if (index == 1) rankColor = Colors.grey.shade400;
                    else if (index == 2) rankColor = Colors.brown.shade400;

                    return Card(
                      elevation: isMe ? 4 : 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: isMe ? const BorderSide(color: Colors.green, width: 2) : BorderSide.none,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: index < 3 ? rankColor.withValues(alpha: 0.2) : Colors.grey.shade100, shape: BoxShape.circle),
                          child: Text('#${index + 1}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: index < 3 ? rankColor : Colors.black54)),
                        ),
                        title: Row(
                          children: [
                            Text(user['username'] ?? 'Anonymous', style: TextStyle(fontWeight: FontWeight.bold, color: isMe ? Colors.green : Colors.black)),
                            if (index < 3) ...[const SizedBox(width: 8), Icon(rankIcon, color: rankColor, size: 18)]
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
                          child: Text('${user['points'] ?? 0} pts', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}