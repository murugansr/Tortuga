import 'package:client_app/screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

class DineInPage extends StatelessWidget {
  final int tableNumber;
  final DateTime reservationDate;
  final String reservationTime;

  const DineInPage({
    Key? key,
    required this.tableNumber,
    required this.reservationDate,
    required this.reservationTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dineInData = {
      'tableNumber': tableNumber,
      'reservationDate': reservationDate.toIso8601String(),
      'reservationTime': reservationTime,
    };

    return Scaffold(
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
                  'Reservation Date: ${reservationDate.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Time: $reservationTime',
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 30, thickness: 1),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Scan QR Code at the Table',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      QrImageView(
                        data: jsonEncode(dineInData),
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
