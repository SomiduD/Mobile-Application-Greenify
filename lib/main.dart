import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'firebase_options.dart'; 
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'features/auth/screens/auth_gate.dart';
import 'core/services/fcm_service.dart'; // ADDED: Import the Auth Gate!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FCMService.init();

  runApp(const GreenifyApp());
}

class GreenifyApp extends StatelessWidget {
  const GreenifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greenify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // CHANGED THIS: Point the app to the AuthGate instead of forcing the login screen
      home: const AuthGate(), 
      
      routes: AppRoutes.routes,
    );
  }
}