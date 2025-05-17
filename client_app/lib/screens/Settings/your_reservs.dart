import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: YourReservations(),
    );
  }
}

class YourReservations extends StatelessWidget {
  const YourReservations({super.key});

  // Fetch reservations from Firestore
  Stream<QuerySnapshot> getReservationsStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw 'User not logged in';
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('reservations')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reservations'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getReservationsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation =
                  reservations[index].data() as Map<String, dynamic>;

              // Display each reservation in a ListTile
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Table #${reservation['tableNumber']}'),
                  subtitle: Text(
                    'Date: ${reservation['reservationDate']} | Time: ${reservation['reservationTime']}',
                  ),
                  trailing: Text('₹${reservation['totalAmount']}'),
                  onTap: () {
                    // Handle click, for example, navigate to another page showing more details or the QR code
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Reservation Details'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Food Items:'),
                                ...List.generate(
                                  reservation['foodItems'].length,
                                  (index) {
                                    final foodItem =
                                        reservation['foodItems'][index];
                                    return Text(
                                      '${foodItem['name']} (Qty: ${foodItem['quantity']})',
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Total Amount: ₹${reservation['totalAmount']}',
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
