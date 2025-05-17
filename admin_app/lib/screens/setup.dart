import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:admin_app/screens/staff/staff_dashboard.dart';
import 'package:admin_app/screens/branch/branch_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedRole = 'Staff'; // Default role
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Variables for OTP functionality (if needed, can be removed in favor of email/password)
  String otpCode = '';

  // Define default email and password for Manager
  final String managerEmail = "manager@tortuga.com";
  final String managerPassword = "manager123";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF0000FF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Tortuga',
                  style: TextStyle(
                    fontFamily: 'InknutAntiqua',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Better Food, Better Mood',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'InknutAntiqua',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Role Selection Dropdown
                DropdownButton<String>(
                  value: selectedRole,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRole = newValue!;
                    });
                  },
                  items:
                      <String>[
                        'Staff',
                        'Branch Manager',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  Icons.email,
                  'Email Address',
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  Icons.lock,
                  'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      // Input Validation
                      if (selectedRole != 'Branch Manager') {
                        if (email.isEmpty || password.isEmpty) {
                          _showError("Email and password cannot be empty.");
                          return;
                        }
                        if (!email.contains('@') || !email.contains('.')) {
                          _showError("Please enter a valid email address.");
                          return;
                        }
                        if (password.length < 6) {
                          _showError("Password must be at least 6 characters.");
                          return;
                        }
                      }

                      if (selectedRole == 'Branch Manager') {
                        // Check if the entered credentials match the manager's credentials
                        if (email == managerEmail &&
                            password == managerPassword) {
                          try {
                            await _signInWithEmailPassword(email, password);
                          } catch (e) {
                            _showError(
                              "Login failed. Please check credentials.",
                            );
                            print("Login Error: $e");
                          }
                        } else {
                          _showError("Invalid Manager credentials.");
                        }
                      } else if (selectedRole == 'Staff') {
                        try {
                          await _signInWithEmailPassword(email, password);
                        } catch (e) {
                          _showError("Login failed. Please check credentials.");
                          print("Login Error: $e");
                        }
                      }
                    },

                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;

      // Automatically update Firestore with role info
      if (uid != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'email': email,
            'role': selectedRole,
            'createdAt': DateTime.now(),
            'lastLogin': DateTime.now(),
          });
        } else {
          await userDoc.update({
            'lastLogin': DateTime.now(),
            'role': selectedRole, // Update the role each login
          });
        }

        // Merge keeps existing fields
      }

      _navigateToDashboard();
    } on FirebaseAuthException catch (e) {
      print('Sign-in failed: ${e.message}');
      _showError(e.message ?? "Authentication error.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Navigate based on role selection
  void _navigateToDashboard() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final role = doc['role'];

    if (role == 'Staff') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StaffDashboard()),
      );
    } else if (role == 'Branch Manager') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BranchDashboard()),
      );
    } else {
      _showError("Unauthorized role detected.");
    }
  }

  // Input field helper
  Widget _buildInputField(
    IconData icon,
    String hintText, {
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
