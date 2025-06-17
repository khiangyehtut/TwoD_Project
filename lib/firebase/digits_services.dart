import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:two_d_project/model/digits_model.dart';

class DigitsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔁 Get reference to digits collection under a specific ledger
  CollectionReference<Map<String, dynamic>> getDigitsRef(String ledgerDoc) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection('ledgers')
        .doc(user.email)
        .collection('ledger')
        .doc(ledgerDoc)
        .collection('digits')
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data,
        );
  }

  /// ✅ Add digits to specific ledger document
  Future<String> addDigitsToLedger(String ledgerDoc, DigitsModel data) async {
    try {
      final digitsRef = getDigitsRef(ledgerDoc);
      await digitsRef.add(data.toJson());
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  /// 🔁 Get real-time digits from specific ledger (optionally filtered by group)
  Stream<List<DigitsModel>> getDigitsFromLedger(String ledgerDoc,
      {String? groupName}) {
    final digitsRef = getDigitsRef(ledgerDoc);

    Query<Map<String, dynamic>> query =
        digitsRef.orderBy('timeStamps', descending: true);

    if (groupName != null && groupName.isNotEmpty) {
      query = query.where('group', isEqualTo: groupName);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DigitsModel.fromJson(doc.data(), doc.id);
      }).toList();
    }).handleError((e) {
      print('Error fetching digits: $e');
    });
  }

  /// ❌ Delete a digit entry
  Future<String> deleteDigit(String ledgerDoc, String documentId) async {
    try {
      final digitsRef = getDigitsRef(ledgerDoc);
      await digitsRef.doc(documentId).delete();
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  /// ✅ Update an existing digit entry
  Future<String> updateDigit(
      String ledgerDoc, String documentId, DigitsModel updatedData) async {
    try {
      final digitsRef = getDigitsRef(ledgerDoc);
      await digitsRef.doc(documentId).update(updatedData.toJson());
      return 'success';
    } catch (e) {
      return 'error';
    }
  }
}
