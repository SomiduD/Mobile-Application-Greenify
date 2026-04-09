import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/screens/login_screen.dart';
import 'add_driver_screen.dart';
import 'qr_generator_screen.dart';
import 'admin_leaderboard_screen.dart';
import 'add_location_screen.dart';
import '../../shopping/screens/chat_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildAnalyticsTab(),
      _buildRequestsTab(),
      _buildDriversTab(),
      _buildChatTab(), // Now completely live!
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Admin Command Center', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Drivers'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
        ],
      ),
    );
  }

  // TAB 1: ANALYTICS & ADMIN TOOLS
  Widget _buildAnalyticsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('System Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            _statCard('Total Users', '1,204', Icons.people, Colors.blue),
            const SizedBox(width: 16),
            _statCard('Pending Pickups', '42', Icons.recycling, Colors.orange),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _statCard('Active Drivers', '15', Icons.local_shipping, Colors.green),
            const SizedBox(width: 16),
            _statCard('Trash Reports', '8', Icons.report_problem, Colors.red),
          ],
        ),
        const SizedBox(height: 32),
        
        // ADMIN TOOLS SECTION
        const Text('Admin Tools', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        
        // 1. QR Generator Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, 
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const QRGeneratorScreen()));
          },
          icon: const Icon(Icons.qr_code_2, color: Colors.white),
          label: const Text('Generate Smart Bin QR Code', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),

        // 2. Add Map Locations Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700, 
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddLocationScreen()));
          },
          icon: const Icon(Icons.add_location_alt, color: Colors.white),
          label: const Text('Add Map Marker (Bins & Centers)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),

        // 3. Manage Leaderboard Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade700, 
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLeaderboardScreen()));
          },
          icon: const Icon(Icons.people, color: Colors.white),
          label: const Text('Manage Top Contributors', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)]),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // TAB 2: LIVE REQUESTS & REPORTS (Firebase Connected)
  Widget _buildRequestsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('pickups').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.green));
        
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No active pickup requests from users.', style: TextStyle(color: Colors.grey, fontSize: 16)));
        }

        final requests = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index].data() as Map<String, dynamic>;
            final isTrashReport = req['type'] == 'Report';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(isTrashReport ? Icons.report_problem : Icons.recycling, color: isTrashReport ? Colors.red : Colors.green),
                title: Text(req['material'] ?? 'Mixed Recycling', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${req['userName'] ?? 'User'} • ${req['address'] ?? 'No Address'}'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: isTrashReport ? Colors.red : Colors.green),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Driver assignment mapping coming soon!')));
                  },
                  child: const Text('Assign', style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // TAB 3: LIVE DRIVERS (Firebase Connected)
  Widget _buildDriversTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.black87, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDriverScreen()));
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Register New Driver', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('drivers').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.green));
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No drivers registered yet.', style: TextStyle(color: Colors.grey)));

              final drivers = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final driverDoc = drivers[index]; 
                  final driver = driverDoc.data() as Map<String, dynamic>;
                  final isOnline = driver['status'] == 'Active';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: isOnline ? Colors.green : Colors.grey.shade400, child: const Icon(Icons.person, color: Colors.white)),
                      title: Text(driver['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${driver['truck']} • ${driver['status']}'),
                      
                      trailing: Switch(
                        value: isOnline,
                        activeColor: Colors.green,
                        onChanged: (bool newValue) async {
                          await FirebaseFirestore.instance.collection('drivers').doc(driverDoc.id).update({
                            'status': newValue ? 'Active' : 'Offline'
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${driver['name']} is now ${newValue ? 'Online' : 'Offline'}')));
                          }
                        },
                      ),
                      
                      onTap: () {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Base Location: Lat ${driver['lat']}, Lng ${driver['lng']}')));
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // TAB 4: LIVE ADMIN CHAT (Firebase Connected)
  Widget _buildChatTab() {
    return StreamBuilder<QuerySnapshot>(
      // Stream all registered users so the Admin can message anyone
      stream: FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'User').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.green));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No users found.', style: TextStyle(color: Colors.grey)));

        final users = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final userId = users[index].id;
            final userName = userData['username'] ?? 'Customer';

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.blue.shade100, child: const Icon(Icons.person, color: Colors.blue)),
                title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userData['email'] ?? ''),
                trailing: const Icon(Icons.chat, color: Colors.green),
                onTap: () {
                  // Opens the real chat room using the user's ID
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                    sellerId: userId, // Keeps the room unique to this user
                    sellerName: userName,
                    itemTitle: 'Support', // The context of the chat
                  )));
                },
              ),
            );
          },
        );
      },
    );
  }
}