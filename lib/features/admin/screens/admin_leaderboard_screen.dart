import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLeaderboardScreen extends StatelessWidget {
  const AdminLeaderboardScreen({super.key});

  // Notice we renamed the main screen's context to 'parentContext'
  void _awardBonusPoints(BuildContext parentContext, String userId, String currentName) {
    final pointsController = TextEditingController();

    showDialog(
      context: parentContext,
      // We renamed the pop-up's context to 'dialogContext' so they don't get confused!
      builder: (dialogContext) => AlertDialog(
        title: Text('Award Points to $currentName'),
        content: TextField(
          controller: pointsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount of Points', prefixIcon: Icon(Icons.add_circle, color: Colors.green)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              int pointsToAdd = int.tryParse(pointsController.text) ?? 0;
              if (pointsToAdd > 0) {
                await FirebaseFirestore.instance.collection('users').doc(userId).update({
                  'points': FieldValue.increment(pointsToAdd)
                });
                
                // 1. Close the pop-up box safely
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
                
                // 2. Show the success message on the MAIN screen safely
                if (parentContext.mounted) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(content: Text('Awarded $pointsToAdd points to $currentName!'), backgroundColor: Colors.green)
                  );
                }
              }
            },
            child: const Text('Award Points', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Contributors'), backgroundColor: Colors.black87, foregroundColor: Colors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').orderBy('points', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No users found.'));

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userData = user.data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(backgroundColor: Colors.green.shade100, child: Text('${index + 1}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                title: Text(userData['username'] ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${userData['email']} • Role: ${userData['role']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${userData['points'] ?? 0} pts', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.card_giftcard, color: Colors.amber),
                      // We pass the main context in here
                      onPressed: () => _awardBonusPoints(context, user.id, userData['username'] ?? 'User'),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}