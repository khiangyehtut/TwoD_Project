import 'package:cloud_firestore/cloud_firestore.dart';

class LedgerModel {
  final String? id;
  final String ledger;
  final int limitBreak;
  final int za;
  final String poukTeeNo;
  final DateTime timeStamps;

  LedgerModel({
    this.id,
    required this.ledger,
    required this.limitBreak,
    required this.za,
    required this.poukTeeNo,
    required this.timeStamps,
  });

  factory LedgerModel.fromJson(Map<String, dynamic> json, String? docId) {
    return LedgerModel(
      id: docId,
      ledger: json['ledger'] ?? '',
      limitBreak: json['limitBreak'] ?? 0,
      za: json['za'] ?? 0,
      poukTeeNo: json['poukTeeNo'] ?? '',
      timeStamps: (json['timeStamps'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ledger': ledger,
      'limitBreak': limitBreak,
      'za': za,
      'poukTeeNo': poukTeeNo,
      'timeStamps': Timestamp.fromDate(timeStamps),
    };
  }
}
