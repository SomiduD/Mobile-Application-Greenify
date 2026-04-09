import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                const Icon(Icons.support_agent, size: 50, color: Colors.green),
                const SizedBox(height: 16),
                const Text('How can we help you?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () {}, child: const Text('Contact Live Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const ExpansionTile(title: Text('How do I earn Green Points?'), children: [Padding(padding: EdgeInsets.all(16.0), child: Text('You earn points every time you schedule a pickup or report trash using the app. Points can be redeemed in the Shopping section!'))]),
          const ExpansionTile(title: Text('When will the truck arrive?'), children: [Padding(padding: EdgeInsets.all(16.0), child: Text('Trucks usually arrive within the time window you selected during the scheduling process. You can track nearby trucks live.'))]),
          const ExpansionTile(title: Text('How do I delete my account?'), children: [Padding(padding: EdgeInsets.all(16.0), child: Text('Please contact live support to request permanent account deletion.'))]),
        ],
      ),
    );
  }
}