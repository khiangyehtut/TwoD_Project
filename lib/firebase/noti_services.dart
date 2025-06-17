import 'package:cloud_firestore/cloud_firestore.dart';

class NotiTextService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('notitext');

  Future<void> addNotiText(Map<String, dynamic> data) async {
    await _collection.add(data);
  }

  Future<void> updateNotiText(String id, Map<String, dynamic> data) async {
    await _collection.doc(id).update(data);
  }

  Future<void> deleteNotiText(String id) async {
    await _collection.doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> getNotiTextList() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => {
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            })
        .toList());
  }
}
