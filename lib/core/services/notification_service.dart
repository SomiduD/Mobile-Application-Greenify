import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
      ),
      body: user == null 
        ? const Center(child: Text('Please log in to view notifications.'))
        : StreamBuilder<QuerySnapshot>(
            // Listens to a 'notifications' collection inside the user's document
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('notifications')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No new notifications.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return _buildNotificationTile(
                    title: doc['title'] ?? 'Notice',
                    subtitle: doc['message'] ?? '',
                  );
                },
              );
            },
          ),
    );
  }

  Widget _buildNotificationTile({required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 1)],
      ),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: AppColors.lightGreen, child: Icon(Icons.notifications, color: AppColors.primaryGreen)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}