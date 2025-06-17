import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:two_d_project/model/agent_model.dart';

class AgentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get agentsRef {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
          code: 'USER_NOT_LOGGED_IN', message: 'User is not logged in.');
    }
    return _firestore.collection('users').doc(user.email).collection('agents');
  }

  Stream<List<AgentModel>> getAgents({String searchText = ''}) {
    Query query = agentsRef;

    if (searchText.isNotEmpty) {
      query = query
          .orderBy('name')
          .startAt([searchText]).endAt(['$searchText\uf8ff']);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              AgentModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    }).handleError((error) {
      print("Error fetching agents: $error");
      return <AgentModel>[]; // Ensure a valid fallback
    });
  }

  Future<String> addAgent(AgentModel agent) async {
    try {
      await agentsRef.add(agent.toJson());
      return 'success';
    } catch (e) {
      print('Error adding agent: $e');
      return 'error';
    }
  }

  Future<String> updateAgent(String id, AgentModel agent) async {
    try {
      await agentsRef.doc(id).update(agent.toJson());
      return 'success';
    } catch (e) {
      print('Error updating agent: $e');
      return 'error';
    }
  }

  Future<String> deleteAgent(String id) async {
    try {
      await agentsRef.doc(id).delete();
      return 'success';
    } catch (e) {
      print('Error deleting agent: $e');
      return 'error';
    }
  }
}
