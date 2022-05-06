import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String rid;
  String uid;
  String finalDonor;
  String message;
  String bloodType;
  bool isComplete;
  DateTime datetime;
  DateTime deadline;
  List<String> donorIds;

  Request({
    this.rid,
    this.uid,
    this.finalDonor = "",
    this.message,
    this.bloodType,
    this.donorIds = const [],
    this.isComplete = false,
    this.datetime,
    this.deadline
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'finalDonor': this.finalDonor,
      'message': this.message,
      'bloodType': this.bloodType,
      'isComplete': this.isComplete,
      'donorIds': this.donorIds,
      'datetime': Timestamp.fromDate(this.datetime),
      'deadline': Timestamp.fromDate(this.deadline)
    };
  }
}