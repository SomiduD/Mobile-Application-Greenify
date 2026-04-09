import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _locationServices = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          SwitchListTile(title: const Text('Push Notifications'), value: _pushNotifications, activeColor: Colors.green, onChanged: (val) => setState(() => _pushNotifications = val)),
          SwitchListTile(title: const Text('Email Alerts'), value: _emailAlerts, activeColor: Colors.green, onChanged: (val) => setState(() => _emailAlerts = val)),
          const Divider(height: 40),
          const Text('Privacy & Permissions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          SwitchListTile(title: const Text('Location Services'), subtitle: const Text('Required for nearby trucks'), value: _locationServices, activeColor: Colors.green, onChanged: (val) => setState(() => _locationServices = val)),
          const Divider(height: 40),
          const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
          ListTile(title: const Text('Terms of Service'), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () {}),
          ListTile(title: const Text('Privacy Policy'), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () {}),
          ListTile(title: const Text('App Version'), trailing: const Text('v1.0.0', style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }
}