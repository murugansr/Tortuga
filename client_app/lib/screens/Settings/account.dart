import 'package:client_app/screens/Settings/policy.dart';
import 'package:client_app/screens/Settings/settings.dart';
import 'package:client_app/screens/Settings/your_reservs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_profile.dart'; // Import EditProfileScreen

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String name = "Loading..."; // Default text while loading
  String phone = "Loading..."; // Default text while loading

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  void _fetchUserData() async {
    try {
      // Get the current user ID from FirebaseAuth
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (userId.isNotEmpty) {
        // Fetch the current user's data from Firestore using the user ID
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users') // Assuming 'users' is the collection name
                .doc(userId) // Use the current user ID
                .get();

        if (userDoc.exists) {
          // Extract data from the document
          var userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            name = userData['name'] ?? 'No Name'; // Fetching name
            phone = userData['phone'] ?? 'No Phone'; // Fetching phone
          });
        } else {
          setState(() {
            name = 'No Name';
            phone = 'No Phone';
          });
        }
      } else {
        setState(() {
          name = 'No Name';
          phone = 'No Phone';
        });
      }
    } catch (e) {
      setState(() {
        name = 'Error loading data';
        phone = 'Error loading data';
      });
    }
  }

  // Function to navigate to EditProfileScreen and receive updated data
  void _navigateToEditProfile() async {
    final updatedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                EditProfileScreen(currentName: name, currentPhone: phone),
      ),
    );

    // If data is updated, update the state
    if (updatedProfile != null) {
      setState(() {
        name = updatedProfile['name'];
        phone = updatedProfile['phone'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD9EBFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Accounts",
          style: TextStyle(
            fontFamily: 'InknutAntiqua',
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF44C5F4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: $name", // Display updated name
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Phone: $phone", // Display updated phone number
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0x80C0C0C0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(
                    context,
                    Icons.bookmark_border,
                    "Tickets",
                    YourReservations(),
                  ),
                  _buildIconButton(
                    context,
                    Icons.info_outline,
                    "FAQ's",
                    FAQs(),
                  ),
                  _buildIconButton(
                    context,
                    Icons.settings_outlined,
                    "Setting",
                    SettingsScreen(name: name, phone: phone),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToEditProfile,
              child: Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    String label,
    Widget screen,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(icon, size: 28, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
