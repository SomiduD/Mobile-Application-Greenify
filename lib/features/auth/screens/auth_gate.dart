import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/screens/main_layout.dart';
import '../../admin/screens/admin_dashboard.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // This constantly listens to see if the user logs in or out
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // 1. If the user is NOT logged in, show them the Login Screen
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // 2. If the user IS logged in, check if they are an Admin or a normal User
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)));
            }

            final data = roleSnapshot.data?.data() as Map<String, dynamic>?;
            final String role = data?['role'] ?? 'user';

            // Send to the correct dashboard!
            if (role == 'admin') {
              return const AdminDashboardScreen();
            }
            return const MainLayout();
          },
        );
      },
    );
  }
}