import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentPhone;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentPhone,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.currentName;
    phoneController.text = widget.currentPhone;
  }

  // Save action for profile
  Future<void> _saveProfile() async {
    String updatedName = firstNameController.text.trim();
    String updatedPhone = phoneController.text.trim();

    if (updatedName.isEmpty || updatedPhone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill out all fields')));
      return;
    }

    setState(() => isSaving = true);

    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'name': updatedName, 'phone': updatedPhone},
        );

        Navigator.pop(context, {'name': updatedName, 'phone': updatedPhone});
      } else {
        throw Exception("User ID not found.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSaving ? null : _saveProfile,
              child:
                  isSaving
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
