import 'package:cloud_firestore/cloud_firestore.dart';

class AgentModel {
  String? id;
  String name;
  String address;
  int percent;

  AgentModel({
    this.id,
    required this.name,
    required this.address,
    required this.percent,
  });

  // Convert a Firestore document into an AgentModel
  factory AgentModel.fromJson(Map<String, dynamic> json, String id) {
    return AgentModel(
      id: id,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      percent: json['percent'] ?? 0,
    );
  }

  // Convert an AgentModel to a Firestore document
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'percent': percent,
    };
  }

  // Firestore converter
  static final converter =
      FirebaseFirestore.instance.collection('agents').withConverter<AgentModel>(
            fromFirestore: (snapshot, _) =>
                AgentModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (agent, _) => agent.toJson(),
          );
}
