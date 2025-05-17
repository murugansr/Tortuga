import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_app/models/staff.dart';
import 'package:admin_app/screens/branch/staffservice.dart';

class ManageStaff extends StatefulWidget {
  const ManageStaff({super.key});

  @override
  State<ManageStaff> createState() => _ManageStaffState();
}

class _ManageStaffState extends State<ManageStaff>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StaffService _staffService = StaffService();
  List<Staff> _staffList = [];

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedRole;
  String? _selectedDepartment;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    List<Staff> staffList = await _staffService.getStaffList();
    setState(() {
      _staffList = staffList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0000FF),
        title: const Text(
          'Manage Staff',
          style: TextStyle(fontFamily: 'InknutAntiqua', color: Colors.white),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          // ignore: deprecated_member_use
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          tabs: const [
            Tab(
              icon: Icon(Icons.list, color: Colors.white),
              text: 'Staff List',
            ),
            Tab(
              icon: Icon(Icons.person_add, color: Colors.white),
              text: 'Add/Edit Staff',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildStaffList(), _buildStaffForm()],
      ),
    );
  }

  Widget _buildStaffList() {
    return _staffList.isEmpty
        ? const Center(child: Text('No staff members found'))
        : ListView.builder(
          itemCount: _staffList.length,
          itemBuilder: (context, index) {
            final staff = _staffList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(staff.name[0]),
                ),
                title: Text(staff.name),
                subtitle: Text('${staff.role} • ${staff.department}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editStaff(staff),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _deleteStaff(staff.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }

  Widget _buildStaffForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),

          DropdownButton<String>(
            hint: const Text('Select Role'),
            value: _selectedRole,
            onChanged: (String? value) {
              setState(() {
                _selectedRole = value;
              });
            },
            items:
                <String>[
                  'Cashier',
                  'Waiter',
                  'Chef',
                  'Bartender',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
          DropdownButton<String>(
            hint: const Text('Select Department'),
            value: _selectedDepartment,
            onChanged: (String? value) {
              setState(() {
                _selectedDepartment = value;
              });
            },
            items:
                <String>[
                  'Management',
                  'Front of House',
                  'Kitchen',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Save Staff'),
          ),
        ],
      ),
    );
  }

  void _editStaff(Staff staff) {
    _nameController.text = staff.name;
    _emailController.text = staff.email;
    _selectedRole = staff.role;
    _selectedDepartment = staff.department;
  }

  void _deleteStaff(String staffId) async {
    await _staffService.deleteStaff(staffId);
    _loadStaff(); // Refresh staff list after deletion
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Staff member removed')));
  }

  void _submitForm() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _nameController.text.isEmpty ||
        _selectedRole == null ||
        _selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      // Try creating Firebase user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      // Send verification email
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      // Create staff object with the new Firebase UID
      Staff staff = Staff(
        id:
            userCredential.user?.uid ??
            'EMP${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        email: email,
        role: _selectedRole!,
        department: _selectedDepartment!,
        joinDate: DateTime.now(),
      );

      // Save staff data in your backend/DB
      await _staffService.saveStaff(staff);
      _loadStaff();

      // Clear form fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _selectedRole = null;
      _selectedDepartment = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Staff member created successfully')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    }
  }
}
