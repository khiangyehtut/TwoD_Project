import 'package:cloud_firestore/cloud_firestore.dart';

class DigitsModel {
  final String id;
  final String group;
  final DateTime timeStamps;
  final int totalSum;
  final List<Map<String, dynamic>> digits;

  DigitsModel({
    required this.id,
    required this.group,
    required this.timeStamps,
    required this.totalSum,
    required this.digits,
  });

  // 🔁 From Firestore document
  factory DigitsModel.fromJson(Map<String, dynamic> json, String docId) {
    return DigitsModel(
      id: docId,
      group: json['group'] ?? '',
      timeStamps: (json['timeStamps'] as Timestamp).toDate(),
      totalSum: json['totalSum'] ?? 0,
      digits: List<Map<String, dynamic>>.from(json['digits'] ?? []),
    );
  }

  // 🔁 To Firestore document
  Map<String, dynamic> toJson() {
    return {
      'group': group,
      'timeStamps': Timestamp.fromDate(timeStamps),
      'totalSum': totalSum,
      'digits': digits,
    };
  }
}
