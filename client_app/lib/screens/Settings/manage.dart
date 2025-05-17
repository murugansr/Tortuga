import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ManageAccountScreen(),
    );
  }
}

class ManageAccountScreen extends StatelessWidget {
  const ManageAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF44C5F4),
        title: const Text(
          "Manage Account",
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
          children: [
            SizedBox(
              width: double.infinity, // Expands to full width
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Logout",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'InknutAntiqua',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15), // Space between buttons
            SizedBox(
              width: double.infinity, // Expands to full width
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Confirm Deletion",
                          style: TextStyle(fontFamily: 'Inder'),
                        ),
                        content: Text(
                          "Are you sure you want to delete your account? This action cannot be undone.",
                          style: TextStyle(fontFamily: 'Inder'),
                        ),
                        actions: [
                          // Cancel Button
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the popup
                            },
                            child: Text("Cancel"),
                          ),
                          // Delete Button
                          TextButton(
                            onPressed: () {
                              // Add delete account logic here
                              Navigator.of(context).pop(); // Close the popup
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Account Deleted Successfully"),
                                ),
                              );
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Delete",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.red,
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
