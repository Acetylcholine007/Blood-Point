import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  String nid;
  String uid;
  String heading;
  String body;
  DateTime datetime;

  AppNotification({
    this.nid,
    this.uid,
    this.heading,
    this.body,
    DateTime datetime,
  }): this.datetime = datetime ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'heading': this.heading,
      'body': this.body,
      'datetime': Timestamp.fromDate(this.datetime)
    };
  }
}