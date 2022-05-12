import 'dart:async';

import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/models/GetRequestResponse.dart';
import 'package:blood_point/models/History.dart';
import 'package:blood_point/models/Request.dart';
import 'package:blood_point/shared/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/AppNotification.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService db = DatabaseService._();

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');
  final CollectionReference requestCollection = FirebaseFirestore.instance.collection('requests');
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');

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
      newNotifs: snapshot.get('newNotifs') ?? 0,
      birthday: snapshot.get('birthday').toDate(),
    );
  }

  Request _requestFromSnapshot(DocumentSnapshot snapshot) {
    return Request(
      rid: snapshot.id,
      uid: snapshot.get('uid') ?? '',
      finalDonor: snapshot.get('finalDonor') ?? '',
      message: snapshot.get('message') ?? '',
      bloodType: snapshot.get('bloodType') ?? '',
      isComplete: snapshot.get('isComplete') ?? false,
      donorIds: List<String>.from(snapshot.get('donorIds') as List) ?? [],
      datetime: snapshot.get('datetime').toDate(),
      deadline: snapshot.get('deadline').toDate(),
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
        finalDonor: doc.get('finalDonor') ?? '',
        message: doc.get('message') ?? '',
        bloodType: doc.get('bloodType') ?? '',
        isComplete: doc.get('isComplete') ?? false,
        donorIds: List<String>.from(doc.get('donorIds') as List) ?? [],
        datetime: doc.get('datetime').toDate(),
        deadline: doc.get('deadline').toDate(),
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
        longitude: doc.get('longitude') ?? 0,
        isDonor: doc.get('isDonor') ?? false,
        bloodType: doc.get('bloodType') ?? 'O',
        newNotifs: doc.get('newNotifs') ?? 0,
        birthday: doc.get('birthday').toDate(),

      );
    }).toList();
  }

  List<History> _historyListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return History(
        hid: doc.id,
        heading: doc.get('heading') ?? '',
        body: doc.get('body') ?? '',
        datetime: doc.get('datetime').toDate(),
      );
    }).toList();
  }

  List<AppNotification> _notificationListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AppNotification(
        nid: doc.id,
        heading: doc.get('heading') ?? '',
        body: doc.get('body') ?? '',
        datetime: doc.get('datetime').toDate(),
      );
    }).toList();
  }

  Future<AccountData> getAccount(String uid) async {
    return userCollection.doc(uid).get().then(_accountFromSnapshot);
  }

  // OPERATOR FUNCTIONS SECTION
  Future removeRequest(String rid, String uid, String bloodType) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await requestCollection.doc(rid).delete();
      await addHistory(History(uid: uid, heading: 'Request Deletion', body: 'You\ve removed your blood request for blood type ${bloodType}'));
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> addRequest(Request request, String uid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';

    try {
      await requestCollection.add(request.toMap());
      await addHistory(History(uid: uid, heading: 'Request Creation', body: 'You\'ve created a blood request for blood type ${request.bloodType}'));
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> editRequest(Request request, String uid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await requestCollection.doc(request.rid).update(request.toMap());
      await addHistory(History(uid: uid, heading: 'Request Editing', body: 'You\'ve edited your blood request for blood type ${request.bloodType}'));
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> terminateRequest(String rid, String uid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await requestCollection.doc(rid).update({'isComplete': true});
      await addHistory(History(uid: uid, heading: 'Request Termination', body: 'You\'ve terminated your blood request with rid=${rid}'));
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> addHistory(History history) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';

    try {
      await historyCollection
        .add(history.toMap())
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
      return result;
    } catch (e) {
      return result;
    }
  }

  Future<String> deleteHistory(String hid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';

    try {
      await historyCollection
          .doc(hid).delete()
          .then((value) => result = 'SUCCESS')
          .catchError((error) => result = error.toString());
      return result;
    } catch (e) {
      return result;
    }
  }

  Future<String> addNotification(AppNotification notification) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';

    try {
      AccountData account = await getUserData(notification.uid);
      await notificationCollection.add(notification.toMap());
      await userCollection.doc(notification.uid).update({'newNotifs': account.newNotifs + 1});
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> deleteNotification(String nid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';

    try {
      await notificationCollection
        .doc(nid).delete()
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
      return result;
    } catch (e) {
      return result;
    }
  }

  Future<String> seenNotification(String uid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';

    try {
      await userCollection.doc(uid).update({'newNotifs': 0});
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> updateDonor(String rid, List<String> donorIds, String uid, String ownerUid, String seekerName, String donorName) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await requestCollection.doc(rid).update({'donorIds': donorIds});
      if(donorIds.contains(uid)) {
        await addHistory(History(uid: uid, heading: 'Donation Offer', body: 'You\'ve offer your blood donation to a request created by ${seekerName}'));
        await addNotification(AppNotification(uid: ownerUid, heading: 'Donation Offer', body: '${donorName} offers to donate blood for your request'));
        await addNotification(AppNotification(uid: uid, heading: 'Preparation Before Blood Donation', body: 'Here is the guide before blood donation'));
      } else {
        await addHistory(History(uid: uid, heading: 'Donation Retraction', body: 'You\'ve pulled out your blood donation offer to a request created by ${seekerName}'));
        await addNotification(AppNotification(uid: ownerUid, heading: 'Donation Retraction', body: '${donorName} pulled out donation offer for your request'));
      }
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> setFinalDonor(String rid, String finalDonor, String uid, String lastDonor,String seekerName, String donorName) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await requestCollection.doc(rid).update({'finalDonor': finalDonor});
      await addHistory(History(uid: uid, heading: 'Donor Selection', body: 'You\'ve chosen $donorName as the blood donor'));
      await addNotification(AppNotification(uid: finalDonor, heading: 'Donation Selection', body: '$seekerName chose you as the donor'));
      if(lastDonor != "") {
        await addNotification(AppNotification(uid: lastDonor, heading: 'Donation Selection', body: 'You are no longer the chosen donor for $seekerName'));
      }
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
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

  Future<AccountData> getUserData(String uid) async {
    try {
      return _accountFromSnapshot(await userCollection.doc(uid).get());
    }catch (e) {
      rethrow;
    }
  }

  Future createAccount(AccountData account, String uid) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await userCollection.doc(uid).set(account.toMap());
      await addHistory(History(uid: uid, heading: 'Account Creation', body: 'You\'ve created your account at ${datetimeFormatter.format(DateTime.now())}'));
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> editAccount(AccountData account) async {
    String result = 'Operation Timeout: Quota was probably reached. Try again the following day.';
    try {
      await userCollection.doc(account.uid).update(account.toMap());
      await addHistory(History(uid: account.uid, heading: 'Account Editing', body: 'You\'ve edited your account information'));
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  // //STREAM SECTION

  Stream<AccountData> getUser(String uid) {
    return userCollection.doc(uid).snapshots().map(_accountFromSnapshot);
  }

  Stream<List<AccountData>> get users {
    return userCollection.where("isDonor", isEqualTo: true).snapshots().map(_accountListFromSnapshot);
  }

  Stream<List<Request>> get requests {
    return requestCollection.orderBy("datetime", descending: true).snapshots().map(_requestListFromSnapshot);
  }

  Stream<List<History>> getHistory(String uid) {
    return historyCollection.where("uid", isEqualTo: uid).orderBy("datetime", descending: true).snapshots().map(_historyListFromSnapshot);
  }

  Stream<List<AppNotification>> getNotifications(String uid) {
    return notificationCollection.where("uid", isEqualTo: uid).orderBy("datetime", descending: true).snapshots().map(_notificationListFromSnapshot);
  }
}