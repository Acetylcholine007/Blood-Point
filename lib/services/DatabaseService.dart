import 'dart:async';

import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/models/GetRequestResponse.dart';
import 'package:blood_point/models/History.dart';
import 'package:blood_point/models/Request.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService db = DatabaseService._();

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');
  final CollectionReference requestCollection = FirebaseFirestore.instance.collection('requests');

  //MAPPING FUNCTION SECTION
  AccountData _accountFromSnapshot(DocumentSnapshot snapshot) {
    return AccountData(
        uid: snapshot.id,
        fullName: snapshot.get('fullName') ?? '',
        username: snapshot.get('username') ?? '',
        accountType: snapshot.get('accountType') ?? '',
        email: snapshot.get('email') ?? '',
        address: snapshot.get('address') ?? '',
        contactNo: snapshot.get('contactNo') ?? '',
        latitude: snapshot.get('latitude') ?? 0,
        longitude: snapshot.get('longitude') ?? 0,
        isDonor: snapshot.get('isDonor') ?? false,
        bloodType: snapshot.get('bloodType') ?? 'O',
    );
  }

  Request _requestFromSnapshot(DocumentSnapshot snapshot) {
    return Request(
      rid: snapshot.id,
      uid: snapshot.get('uid') ?? '',
      message: snapshot.get('message') ?? '',
      bloodType: snapshot.get('bloodType') ?? '',
      isComplete: snapshot.get('isComplete') ?? false,
      donorIds: List<String>.from(snapshot.get('donorIds') as List) ?? [],
      datetime: snapshot.get('datetime').toDate(),
    );
  }
  //
  List<Request> _requestListFromSnapshot(QuerySnapshot snapshot) {
    snapshot.docs.map((doc) {
    });
    return snapshot.docs.map((doc) {
      return Request(
        rid: doc.id,
        uid: doc.get('uid') ?? '',
        message: doc.get('message') ?? '',
        bloodType: doc.get('bloodType') ?? '',
        isComplete: doc.get('isComplete') ?? false,
        donorIds: List<String>.from(doc.get('donorIds') as List) ?? [],
        datetime: doc.get('datetime').toDate(),
      );
    }).toList();
  }

  List<AccountData> _accountListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AccountData(
        uid: doc.id,
        fullName: doc.get('fullName') ?? '',
        username: doc.get('username') ?? '',
        accountType: doc.get('accountType') ?? '',
        email: doc.get('email') ?? '',
        address: doc.get('address') ?? '',
        contactNo: doc.get('contactNo') ?? '',
        latitude: doc.get('latitude') ?? 0,
        longitude: doc.get('email') ?? 0,
        isDonor: doc.get('isDonor') ?? false,
        bloodType: doc.get('bloodType') ?? 'O',

      );
    }).toList();
  }

  List<History> _historyListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return History(
          hid: doc.id
      );
    }).toList();
  }

  Future<AccountData> getAccount(String uid) async {
    return userCollection.doc(uid).get().then(_accountFromSnapshot);
  }

  // OPERATOR FUNCTIONS SECTION
  Future removeRequest(String rid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await requestCollection
        .doc(rid).delete()
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
      return result;
    } catch (e) {
      return result;
    }
  }

  Future<String> addRequest(Request request) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';

    try {
      await requestCollection
          .add(request.toMap())
          .then((value) => result = 'SUCCESS')
          .catchError((error) => result = error.toString());

      return result;
    } catch (e) {
      print(e);
      return result;
    }
  }

  Future<String> editRequest(Request request) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await requestCollection.doc(request.rid)
          .update(request.toMap())
          .then((value) => result = 'SUCCESS')
          .catchError((error) => result = error.toString());
      return result;
    } catch (e) {
      return result;
    }
  }

  Future<GetRequestResponse> getRequest(String rid) async {
    GetRequestResponse result = GetRequestResponse(null, 'Operation Timeout: Quota was probably reached. Try again the following day.');
    try {
      await requestCollection.doc(rid).get()
          .then((DocumentSnapshot snapshot) => result = GetRequestResponse(_requestFromSnapshot(snapshot), 'SUCCESS'))
          .catchError((error) => GetRequestResponse(null, 'FAILED'));
      return result;
    }catch (e) {
      return result;
    }
  }

  Future createAccount(AccountData person, String email, String uid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await userCollection.doc(uid).set({
        'fullName': person.fullName,
        'username': person.username,
        'accountType': person.accountType,
        'address': person.address,
        'contactNo': person.contactNo,
        'latitude': person.latitude,
        'longitude': person.longitude,
        'isDonor': person.isDonor,
        'bloodType': person.bloodType,
        'email': email
      })
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
      return result;
    } catch (e) {
      return result;
    }
  }

  Future<String> editAccount(AccountData account) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await userCollection.doc(account.uid).update({
        'fullName': account.fullName,
        'username': account.username,
        'address': account.address,
        'contactNo': account.contactNo,
        'latitude': account.latitude,
        'longitude': account.longitude,
        'isDonor': account.isDonor,
        'bloodType': account.bloodType,
      })
          .then((value) => result = 'SUCCESS')
          .catchError((error) => result = error.toString());
      return result;
    } catch (e) {
      return result;
    }
  }

  // //STREAM SECTION

  Stream<AccountData> getUser(String uid) {
    return userCollection.doc(uid).snapshots().map(_accountFromSnapshot);
  }

  Stream<List<AccountData>> get users {
    return userCollection.snapshots().map(_accountListFromSnapshot);
  }

  Stream<List<Request>> get requests {
    return requestCollection.snapshots().map(_requestListFromSnapshot);
  }

  Stream<List<History>> get history {
    return historyCollection.snapshots().map(_historyListFromSnapshot);
  }
}