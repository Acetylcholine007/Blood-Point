import 'package:cloud_firestore/cloud_firestore.dart';

class AccountData {
  String uid;
  String fullName;
  String username;
  String accountType;
  String email;
  String address;
  String contactNo;
  double latitude;
  double longitude;
  bool isVerified;
  bool isDonor;
  int newNotifs;
  String bloodType;
  DateTime birthday;

  AccountData({
    this.uid,
    this.fullName,
    this.username,
    this.accountType = 'STANDARD',
    this.email,
    this.address,
    this.contactNo,
    this.latitude,
    this.longitude,
    this.isDonor,
    this.bloodType,
    this.newNotifs,
    this.birthday
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': this.fullName,
      'username': this.username,
      'accountType': this.accountType,
      'address': this.address,
      'contactNo': this.contactNo,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'isDonor': this.isDonor,
      'bloodType': this.bloodType,
      'newNotifs': this.newNotifs,
      'birthday': Timestamp.fromDate(this.birthday),
      'email': this.email
    };
  }

  AccountData copy() => AccountData(
    uid: this.uid,
    fullName: this.fullName,
    accountType: this.accountType,
    email: this.email,
    address: this.address,
    contactNo: this.contactNo,
    latitude: this.latitude,
    longitude: this.longitude,
    isDonor: this.isDonor,
    bloodType: this.bloodType,
    newNotifs: this.newNotifs,
    birthday: this.birthday
  );

  get age {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    int month1 = currentDate.month;
    int month2 = birthday.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthday.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}