import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String rid;
  String uid;
  String message;
  String bloodType;
  bool isComplete;
  DateTime datetime;
  List<String> donorIds;

  Request({
    this.rid,
    this.uid,
    this.message,
    this.bloodType,
    this.donorIds = const [],
    this.isComplete = false,
    this.datetime
  });

  Map<String, dynamic> toMap() {
    print(this.datetime);
    return {
      'uid': this.uid,
      'message': this.message,
      'bloodType': this.bloodType,
      'isComplete': this.isComplete,
      'donorIds': this.donorIds,
      'datetime': Timestamp.fromDate(this.datetime)
    };
  }
}