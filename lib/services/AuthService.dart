import 'package:firebase_auth/firebase_auth.dart';

import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/models/Account.dart';
import 'package:blood_point/services/DatabaseService.dart';

import '../models/History.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //MAPPING FUNCTION SECTION

  Account _userFromFirebaseUser(User user) {
    return user != null ? Account(
        uid: user.uid,
        email: user.email,
        isEmailVerified: user.emailVerified
    ) : null;
  }

  //STREAM SECTION

  Stream<Account> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebaseUser(user));
  }

  //OPERATOR FUNCTIONS SECTION

  Future<String> signInEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      if(!_auth.currentUser.emailVerified) {
        String result = await resendVerification(_auth.currentUser);
        return result == 'SUCCESS' ? 'Email is not yet verified. Verification email has been re-sent.' : result;
      }
      return 'SUCCESS';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future<String> register(AccountData accountData, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      User user = result.user;

      await DatabaseService.db.createAccount(accountData, user.uid);
      await user.sendEmailVerification();
      await _auth.currentUser.reload();
      await _auth.signOut();
      return 'SUCCESS';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future<String> signOut() async {
    String result  = '';
    await _auth.signOut()
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> changePassword(String newPassword, String uid) async {
    String result  = '';
    try {
      await _auth.currentUser.updatePassword(newPassword);
      await DatabaseService.db.addHistory(History(uid: uid, heading: 'Change Password', body: 'You\'ve changed your password'));
      result = 'SUCCESS';
      return result;
    } catch (e) {
      result = e.toString();
      return result;
    }
  }

  Future<String> resendVerification(User user) async {
    try {
      user.sendEmailVerification();

      return 'SUCCESS';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);

      return 'SUCCESS';
    } on FirebaseAuthException catch (error) {
      return error.message;
    }
  }

  FirebaseAuth get auth => _auth;
}