import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_gate.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      // 1. Create the user in Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;
      
      if (user != null) {
        // 2. Create their profile in Firestore with the 200-Point Bonus!
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': 'User', // CRITICAL: Capital 'U' so the Admin Dashboard can see them in the Chat tab!
          'points': 200, // SIGN-UP BONUS
          'rank': 'Bronze',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // 3. Generate the Automated Welcome Message in Firestore
        final chatRoomId = "${user.uid}_admin_Support"; 
        await FirebaseFirestore.instance.collection('chats').doc(chatRoomId).collection('messages').add({
          'senderId': 'admin',
          'text': 'Welcome to Greenify! 🌱 We have gifted you 200 Green Points to get started. Let us know if you have any questions!',
          'timestamp': FieldValue.serverTimestamp(),
        });

        // 4. Send them to the AuthGate
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthGate()));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Sign up failed'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 8),
              const Text('Join the Greenify movement today.', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 40),
              
              TextField(
                controller: _nameController, 
                decoration: InputDecoration(hintText: 'Full Name', prefixIcon: const Icon(Icons.person_outline), filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _emailController, 
                keyboardType: TextInputType.emailAddress, 
                decoration: InputDecoration(hintText: 'Email address', prefixIcon: const Icon(Icons.email_outlined), filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _passwordController, 
                obscureText: true, 
                decoration: InputDecoration(hintText: 'Password', prefixIcon: const Icon(Icons.lock_outline), filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}