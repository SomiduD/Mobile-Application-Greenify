import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      // The app will start at the login screen
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}