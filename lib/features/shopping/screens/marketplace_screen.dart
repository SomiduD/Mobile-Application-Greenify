import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_item_screen.dart';
import 'item_detail_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Electronics', 'Furniture', 'Clothing', 'Books', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Green Market', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const AddItemScreen())); },
        icon: const Icon(Icons.sell, color: Colors.white),
        label: const Text('Sell Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Introductory Banner
          Container(
            width: double.infinity, margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade700]), borderRadius: BorderRadius.circular(20)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.recycling, color: Colors.white, size: 40),
                SizedBox(height: 12),
                Text('Give items a second life!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Buy and sell pre-loved goods to reduce waste in Sri Lanka.', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // Categories Horizontal Scroll
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
                    onSelected: (bool selected) { setState(() => _selectedCategory = category); },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Live Feed of Items
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('marketplace').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.green));
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No items for sale yet. Be the first!'));

                // Filter items based on selected category
                final docs = snapshot.data!.docs.where((doc) {
                  if (_selectedCategory == 'All') return true;
                  return (doc.data() as Map<String, dynamic>)['category'] == _selectedCategory;
                }).toList();

                if (docs.isEmpty) return Center(child: Text('No $_selectedCategory available right now.'));

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.75),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index].data() as Map<String, dynamic>;
                    final base64Image = item['imageBase64'] as String?;

                    return GestureDetector(
                      onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetailScreen(itemData: item))); },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1)]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: (base64Image != null && base64Image.isNotEmpty)
                                      ? Image.memory(base64Decode(base64Image), fit: BoxFit.cover)
                                      : Container(color: Colors.grey.shade200, child: const Icon(Icons.image)),
                                ),
                              ),
                            ),
                            // Details
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('Rs ${item['price']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Row(children: [const Icon(Icons.location_on, size: 12, color: Colors.grey), const SizedBox(width: 4), Expanded(child: Text(item['location'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis))]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}