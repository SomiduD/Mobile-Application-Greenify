import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold))),
      // We use a StreamBuilder to fetch live data from Firebase!
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No new notifications!', style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index].data() as Map<String, dynamic>;
              final title = notif['title'] ?? 'Alert';
              final body = notif['body'] ?? '';
              final isUnread = notif['isUnread'] ?? false;
              
              // Handle Timestamp conversion safely
              String timeString = 'Just now';
              if (notif['timestamp'] != null) {
                final DateTime date = (notif['timestamp'] as Timestamp).toDate();
                timeString = '${date.day}/${date.month} - ${date.hour}:${date.minute}';
              }

              return Card(
                color: isUnread ? Colors.green.shade50 : Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.notifications, color: Colors.white)),
                  title: Text(title, style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(body),
                        const SizedBox(height: 8),
                        Text(timeString, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}