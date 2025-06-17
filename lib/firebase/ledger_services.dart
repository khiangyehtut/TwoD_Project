import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:two_d_project/model/ledger_model.dart';

class LedgerService {
  final _firestore = FirebaseFirestore.instance;

  DocumentReference getLedgerDocRef(String typedDocName) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection('ledgers')
        .doc(user.email)
        .collection('ledger')
        .doc(typedDocName);
  }

  Future<String> addLedger(String typedDocName, LedgerModel data) async {
    try {
      final docRef = getLedgerDocRef(typedDocName);
      await docRef.set(data.toJson());
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

// Firestore service class မှာ
  Stream<DocumentSnapshot<Map<String, dynamic>>> getAdminInfo() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return FirebaseFirestore.instance
        .collection('ledgers')
        .doc(user.email)
        .snapshots();
  }

  Stream<List<LedgerModel>> getAllLedgers({String searchText = ''}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      return const Stream.empty();
    }

    final ledgerCollection = _firestore
        .collection('ledgers')
        .doc(user.email)
        .collection('ledger')
        .orderBy('timeStamps', descending: true);

    return ledgerCollection.snapshots().map((snapshot) {
      final allLedgers = snapshot.docs
          .map((doc) => LedgerModel.fromJson(doc.data(), doc.id))
          .toList();

      if (searchText.isEmpty) return allLedgers;

      return allLedgers
          .where((ledger) =>
              ledger.ledger.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Stream<LedgerModel?> getLedgerById(String ledgerId) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      return const Stream.empty();
    }

    final docRef = _firestore
        .collection('ledgers')
        .doc(user.email)
        .collection('ledger')
        .doc(ledgerId);

    return docRef.snapshots().map((snapshot) {
      if (snapshot.exists) {
        return LedgerModel.fromJson(snapshot.data()!, snapshot.id);
      } else {
        return null;
      }
    });
  }

  Future<String> deleteLedger(String typedDocName) async {
    try {
      await _firestore
          .collection('ledgers')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('ledger')
          .doc(typedDocName)
          .delete();

      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  Future<String> updateLedger(
      String typedDocName, LedgerModel updatedData) async {
    try {
      final docRef = getLedgerDocRef(typedDocName);
      await docRef.update(updatedData.toJson());
      return 'success';
    } catch (e) {
      return 'error';
    }
  }
}
