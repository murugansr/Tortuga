import 'package:client_app/screens/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ProfileName());
  }
}

class ProfileName extends StatefulWidget {
  const ProfileName({super.key});

  @override
  State<ProfileName> createState() => _ProfileNameState();
}

class _ProfileNameState extends State<ProfileName> {
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  // Function to save name to Firestore
  Future<void> _saveName() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter your name')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        // Store name and phone number in Firestore
        await userDoc.set({
          'userID': user.uid,
          'phone': user.phoneNumber,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Show success message
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Name saved successfully')));

        // Navigate to the Home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving name: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9EBFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xFF44C5F4), // Blue Header Background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54, // Predefined color with 54% opacity
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "TORTUGA",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'InknutAntiqua',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    "Better Food, Better Mood",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inder',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Entry Name Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What should we call you?',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inder',
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your Name...",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inder',
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 162, 162, 162),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 150), // Add padding
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF17430), // Orange color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child:
                    isLoading
                        ? CircularProgressIndicator()
                        : Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inder',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
