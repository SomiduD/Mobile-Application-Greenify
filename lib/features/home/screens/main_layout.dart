import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'tips_screen.dart';
import 'notifications_screen.dart';
import '../../profile/screens/account_screen.dart';
import '../../recycling/screens/pickup_form_screen.dart'; // Or wherever your "Sell Recyclables" screen is

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TipsScreen(),
    const NotificationsScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          // Pops open your "Sell Recyclables" screen!
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PickupFormScreen()));
        },
        child: const Icon(Icons.recycling, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _buildNavItem(Icons.lightbulb_outline, Icons.lightbulb, 'Tips', 1),
              const SizedBox(width: 48), // Space for the center button
              _buildNavItem(Icons.notifications_none, Icons.notifications, 'Notifications', 2),
              _buildNavItem(Icons.person_outline, Icons.person, 'Account', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData outlineIcon, IconData solidIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSelected ? solidIcon : outlineIcon, color: isSelected ? Colors.green : Colors.grey),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.green : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}