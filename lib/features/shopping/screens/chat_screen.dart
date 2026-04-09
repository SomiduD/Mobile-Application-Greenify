import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String sellerId;
  final String sellerName;
  final String itemTitle;

  const ChatScreen({super.key, required this.sellerId, required this.sellerName, required this.itemTitle});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _currentUser = FirebaseAuth.instance.currentUser!;

  // Creates a unique chat room ID between these two specific users for this specific item
  String get _chatRoomId {
    List<String> ids = [_currentUser.uid, widget.sellerId];
    ids.sort(); // Ensures the ID is always the same no matter who opens it
    return "${ids[0]}_${ids[1]}_${widget.itemTitle.replaceAll(' ', '')}";
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    final text = _messageController.text.trim();
    _messageController.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatRoomId)
        .collection('messages')
        .add({
      'senderId': _currentUser.uid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.sellerName}'), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Column(
        children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(8), color: Colors.green.shade50, child: Text('Inquiring about: ${widget.itemTitle}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').doc(_chatRoomId).collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // Starts at the bottom!
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['senderId'] == _currentUser.uid;
                    
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: isMe ? Colors.green : Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
                        child: Text(msg['text'] ?? '', style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Chat Input Box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _messageController, decoration: InputDecoration(hintText: 'Type a message...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))),
                IconButton(icon: const Icon(Icons.send, color: Colors.green), onPressed: _sendMessage),
              ],
            ),
          )
        ],
      ),
    );
  }
}