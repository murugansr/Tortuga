import 'package:client_app/screens/Settings/manage.dart'; // Import the ManageAccountScreen
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String name;
  final String phone;

  const SettingsScreen({super.key, required this.name, required this.phone});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String userName;
  late String userPhone;

  @override
  void initState() {
    super.initState();
    userName = widget.name;
    userPhone = widget.phone;
  }

  // Function to handle navigation to ManageAccountScreen
  void _navigateToManageAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManageAccountScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF44C5F4),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'InknutAntiqua',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      backgroundColor: Color(0xFFD9EBFC),
      body: Padding(
        padding: const EdgeInsets.all(20), // Adds side padding
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligns content to the left
          children: [
            // Display the user's name and phone number
            Text(
              "User Name: $userName",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10), // Adds space between text and button
            Text(
              "Phone: $userPhone",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 30), // Adds space before the button
            SizedBox(
              width: double.infinity, // Expands to full width
              child: ElevatedButton(
                onPressed: _navigateToManageAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Manage Account",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'InknutAntiqua',
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
