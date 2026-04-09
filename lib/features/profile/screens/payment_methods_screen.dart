import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Linked Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade900]), borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.credit_card, color: Colors.white, size: 30), Text('VISA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))]),
                  const SizedBox(height: 24),
                  const Text('**** **** **** 4242', style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Card Holder', style: TextStyle(color: Colors.white70, fontSize: 12)), Text('Expires', style: TextStyle(color: Colors.white70, fontSize: 12))]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Eco Warrior', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text('12/28', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adding cards coming soon!'))); },
              icon: const Icon(Icons.add, color: Colors.green),
              label: const Text('Add New Payment Method', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}