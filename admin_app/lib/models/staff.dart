import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  final String id;
  final String name;
  final String email;
  final String role;
  final String department;
  final DateTime joinDate;
  final String? phone;
  final String? profileImage;
  String bio;
  String avatarUrl;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.joinDate,
    this.phone,
    this.profileImage,
    this.bio = '',
    this.avatarUrl = '',
  });

  factory Staff.fromFirestore(Map<String, dynamic> data) {
    return Staff(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      department: data['department'] ?? '',
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      phone: data['phone'],
      profileImage: data['profileImage'],
      bio: data['bio'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'department': department,
      'joinDate': joinDate,
      'phone': phone,
      'profileImage': profileImage,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }
}
