import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_app/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

class TableTicket extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const TableTicket({super.key, required this.orderData});

  Future<void> saveTableTicket(BuildContext context) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        // Handle the case when the user is not logged in
        throw 'User not logged in';
      }

      // Firestore reference to the user's reservations collection
      final reservationRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reservations');

      // Add the order data to Firestore
      await reservationRef.add({
        'foodItems': orderData['foodItems'],
        'reservationDate': orderData['reservationDate'],
        'reservationTime': orderData['reservationTime'],
        'tableNumber': orderData['tableNumber'],
        'totalAmount': orderData['totalAmount'],
        'qrCodeUrl': orderData,
        'timestamp': Timestamp.now(), // Optional: for sorting
      });

      // Optionally, show a confirmation message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reservation saved!')));
    } catch (e) {
      // Handle error (e.g., network issue or Firebase errors)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> foodItems = orderData['foodItems'];
    final String reservationDate = orderData['reservationDate'];
    final String reservationTime = orderData['reservationTime'];
    final int tableNumber = orderData['tableNumber'];
    final double totalAmount = orderData['totalAmount'];

    return Scaffold(
      backgroundColor: const Color(0xFFEEF9FF),
      appBar: AppBar(
        title: const Text(
          'Table Ticket',
          style: TextStyle(
            fontFamily: 'InknutAntiqua',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF44C5F4),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Table #$tableNumber',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Reservation Date: ${reservationDate.split('T').first}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Time: $reservationTime',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 30, thickness: 1),
                const Text(
                  'Ordered Items:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final item = foodItems[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item['name']),
                        subtitle: Text('Qty: ${item['quantity']}'),
                        trailing: Text(
                          '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: ₹${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Scan QR Code to View Ticket',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      QrImageView(
                        data: jsonEncode(orderData),
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await saveTableTicket(context); // Save the table ticket
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
