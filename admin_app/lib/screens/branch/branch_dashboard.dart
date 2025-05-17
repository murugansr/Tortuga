import 'package:admin_app/screens/branch/branch_menu.dart';
import 'package:admin_app/screens/branch/branch_profile.dart';
import 'package:admin_app/screens/branch/manage_staff.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BranchDashboard(),
    );
  }
}

class BranchDashboard extends StatelessWidget {
  const BranchDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 70, bottom: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF0000FF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "TORTUGA",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'InknutAntiqua',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Better Food, Better Mood",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inder',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          // Buttons Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildOption(context, "Profile", Icons.person, BranchProfile()),
                _buildOption(
                  context,
                  "Item Menu",
                  Icons.restaurant_menu,
                  BranchMenu(),
                ),
                _buildOption(
                  context,
                  "Manage Staff",
                  Icons.people_alt_outlined,
                  ManageStaff(),
                ),
                _buildLogoutButton(context, "Logout", Icons.logout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(20),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black87),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inder',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLogoutButton(BuildContext context, String title, IconData icon) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.all(20),
    ),
    onPressed: () {
      // Implement logout functionality
      Navigator.popUntil(context, (route) => route.isFirst);
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.black87),
        const SizedBox(height: 10),
        Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Inder',
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}
