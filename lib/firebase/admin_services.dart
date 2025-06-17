import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminServices {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getAdminInfo() {
    final user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('ledgers')
        .doc(user?.email)
        .snapshots();
  }
}
