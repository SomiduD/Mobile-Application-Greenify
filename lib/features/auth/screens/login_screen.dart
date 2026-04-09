import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_gate.dart';
import 'signup_screen.dart'; // Added this import!

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthGate()));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed. Check credentials.'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // This is the magic line that prevents the yellow/black keyboard error!
      resizeToAvoidBottomInset: true, 
      body: SafeArea(
        child: Center(
          // Wrapping it in a ScrollView allows the screen to slide up!
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.recycling, size: 60, color: Colors.green),
                ),
                const SizedBox(height: 24),
                const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 40),
                
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Email address', prefixIcon: const Icon(Icons.email_outlined), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: const Icon(Icons.visibility_off), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity, height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                
                // FIXED: Now it's a clickable button that goes to the Sign Up Screen!
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                  },
                  child: const Text("Don't have an account yet? Sign up", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}