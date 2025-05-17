import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StaffProfile(),
    );
  }
}

class StaffProfile extends StatefulWidget {
  const StaffProfile({super.key});

  @override
  State<StaffProfile> createState() => _StaffProfileState();
}

class _StaffProfileState extends State<StaffProfile> {
  Profile _profile = Profile(
    staffId: '',
    name: '',
    email: '',
    phone: '',
    bio: '',
    avatarUrl: '',
    department: '',
    role: '',
    joinDate: '',
  );
  bool _isEditing = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('staff_profiles')
              .doc('EMPMNG001') // You can pass this dynamically
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _profile = Profile(
            staffId: data['staffId'],
            name: data['name'],
            email: data['email'],
            phone: data['phone'],
            bio: data['bio'],
            avatarUrl: data['avatarUrl'],
            department: data['department'],
            role: data['role'],
            joinDate: data['joinDate'],
          );
          _isLoading = false;
        });
      } else {
        // Handle not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff profile not found')),
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0000FF),
        title: const Text(
          'Staff Profile',
          style: TextStyle(fontFamily: "InknutAntiqua", color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          if (!_isEditing && !_isLoading)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              tooltip: 'Edit Profile',
              onPressed: () => setState(() => _isEditing = true),
            )
          else if (_isEditing)
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'SAVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _isEditing ? _buildEditForm() : _buildProfileView(),
              ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage:
                  _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : NetworkImage(_profile.avatarUrl) as ImageProvider,
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified, color: Colors.white, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _profile.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          _profile.role,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildProfileInfoItem(
                  Icons.badge,
                  'Staff ID',
                  _profile.staffId,
                ),
                _buildProfileInfoItem(Icons.email, 'Email', _profile.email),
                _buildProfileInfoItem(Icons.phone, 'Phone', _profile.phone),
                _buildProfileInfoItem(
                  Icons.work,
                  'Department',
                  _profile.department,
                ),
                _buildProfileInfoItem(
                  Icons.calendar_today,
                  'Join Date',
                  _profile.joinDate,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_profile.bio, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: _changeProfilePicture,
            child: CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(_profile.avatarUrl),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(70),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            initialValue: _profile.staffId,
            decoration: const InputDecoration(
              labelText: 'Staff ID',
              prefixIcon: Icon(Icons.badge),
              filled: true,
              enabled: false,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _profile.name,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person),
            ),
            validator:
                (value) => value?.isEmpty ?? true ? 'Required field' : null,
            onSaved: (value) => _profile = _profile.copyWith(name: value ?? ''),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _profile.email,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Required field';
              if (!value!.contains('@')) return 'Invalid email format';
              return null;
            },
            onSaved:
                (value) => _profile = _profile.copyWith(email: value ?? ''),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _profile.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            onSaved:
                (value) => _profile = _profile.copyWith(phone: value ?? ''),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _profile.department,
            decoration: const InputDecoration(
              labelText: 'Department',
              prefixIcon: Icon(Icons.work),
            ),
            onSaved:
                (value) =>
                    _profile = _profile.copyWith(department: value ?? ''),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _profile.bio,
            decoration: const InputDecoration(
              labelText: 'About',
              prefixIcon: Icon(Icons.info),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            onSaved: (value) => _profile = _profile.copyWith(bio: value ?? ''),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('SAVE PROFILE'),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _isEditing = false),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  void _changeProfilePicture() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Profile Photo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() => _pickedImage = File(pickedFile.path));
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() => _pickedImage = File(pickedFile.path));
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    // Simulate API call delay
    await FirebaseFirestore.instance
        .collection('staff')
        .doc(_profile.staffId)
        .update({
          'name': _profile.name,
          'email': _profile.email,
          'phone': _profile.phone,
          'bio': _profile.bio,
          'department': _profile.department,
        });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class Profile {
  final String staffId;
  String name;
  String email;
  String phone;
  String bio;
  String avatarUrl;
  String department;
  String role;
  String joinDate;

  Profile({
    required this.staffId,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.avatarUrl,
    required this.department,
    required this.role,
    required this.joinDate,
  });

  Profile copyWith({
    String? staffId,
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? avatarUrl,
    String? department,
    String? role,
    String? joinDate,
  }) {
    return Profile(
      staffId: staffId ?? this.staffId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      department: department ?? this.department,
      role: role ?? this.role,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}
