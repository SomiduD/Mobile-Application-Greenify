import 'dart:convert';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> itemData;
  const ItemDetailScreen({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    final imageBase64 = itemData['imageBase64'] as String?;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            onPressed: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
    sellerId: itemData['sellerId'] ?? '',
    sellerName: itemData['sellerName'] ?? 'Seller',
    itemTitle: itemData['title'] ?? 'Item',
  )));
},
            icon: const Icon(Icons.chat, color: Colors.white),
            label: const Text('Contact Seller', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big Image
            SizedBox(
              height: 350, width: double.infinity,
              child: (imageBase64 != null && imageBase64.isNotEmpty) 
                  ? Image.memory(base64Decode(imageBase64), fit: BoxFit.cover) 
                  : Container(color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported, size: 50)),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)), child: Text(itemData['category'] ?? 'Item', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                      Text('Rs ${itemData['price']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(itemData['title'] ?? 'No Title', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.location_on, color: Colors.grey, size: 18), const SizedBox(width: 4), Text(itemData['location'] ?? 'Unknown Location', style: const TextStyle(color: Colors.grey, fontSize: 14))]),
                  const Divider(height: 40),
                  
                  // Seller Info
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Listed by', style: TextStyle(color: Colors.grey, fontSize: 12)), Text(itemData['sellerName'] ?? 'Anonymous', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
                    ],
                  ),
                  const Divider(height: 40),
                  
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(itemData['description'] ?? 'No description provided.', style: const TextStyle(height: 1.5, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}