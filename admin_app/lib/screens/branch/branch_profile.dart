import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BranchProfile());
  }
}

class BranchProfile extends StatefulWidget {
  @override
  _BranchProfileState createState() => _BranchProfileState();
}

class _BranchProfileState extends State<BranchProfile> {
  String name = 'Murugan Sounderrajan';
  String email = 'murugan@tortuga.com';
  String phone = '+91 12345 67890';
  String imageUrl =
      'https://www.example.com/profile_picture.jpg'; // Replace with a real image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0000FF),
        title: const Text(
          'Manager Profile',
          style: TextStyle(fontFamily: "InknutAntiqua", color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Restaurant Outlet Manager',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: $email'),
            SizedBox(height: 8),
            Text('Phone: $phone'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the profile edit screen and wait for result
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => EditProfilePage(
                          currentName: name,
                          currentEmail: email,
                          currentPhone: phone,
                        ),
                  ),
                ).then((updatedProfile) {
                  if (updatedProfile != null) {
                    setState(() {
                      name = updatedProfile['name'];
                      email = updatedProfile['email'];
                      phone = updatedProfile['phone'];
                    });
                  }
                });
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;

  const EditProfilePage({
    Key? key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _phoneController = TextEditingController(text: widget.currentPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // If form is valid, save the changes
                    final updatedProfile = {
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                    };
                    Navigator.pop(context, updatedProfile);
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
