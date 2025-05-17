import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_app/models/staff.dart';

class StaffService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add or update staff
  Future<void> saveStaff(Staff staff) async {
    try {
      // Use staff.staffId as the document ID to ensure uniqueness
      await _db
          .collection('staff')
          .doc(staff.id)
          .set(staff.toMap(), SetOptions(merge: true));
      print('Staff saved successfully');
    } catch (e) {
      print('Error saving staff: $e');
    }
  }

  // Get a single staff by staffId
  Future<Staff?> getStaffById(String staffId) async {
    try {
      DocumentSnapshot snapshot =
          await _db.collection('staff').doc(staffId).get();
      if (snapshot.exists) {
        return Staff.fromFirestore(snapshot.data() as Map<String, dynamic>);
      } else {
        print('Staff not found');
        return null; // Staff not found
      }
    } catch (e) {
      print('Error fetching staff by ID: $e');
      return null;
    }
  }

  // Get all staff
  Future<List<Staff>> getStaffList() async {
    try {
      QuerySnapshot snapshot = await _db.collection('staff').get();
      return snapshot.docs.map((doc) {
        return Staff.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching staff: $e');
      return [];
    }
  }

  // Delete staff
  Future<void> deleteStaff(String staffId) async {
    try {
      await _db.collection('staff').doc(staffId).delete();
      print('Staff deleted successfully');
    } catch (e) {
      print('Error deleting staff: $e');
    }
  }
}
