import 'package:blood_point/models/Account.dart';
import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/models/AppNotification.dart';
import 'package:blood_point/models/History.dart';
import 'package:blood_point/models/Request.dart';
import 'package:blood_point/screens/mainPages/LoginPage.dart';
import 'package:blood_point/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MainWrapper.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Account>(context);

    if(authUser != null && authUser.isEmailVerified) {
      return MultiProvider(
        providers: [
          StreamProvider<AccountData>.value(value: DatabaseService.db.getUser(authUser.uid), initialData: null),
          StreamProvider<List<Request>>.value(value: DatabaseService.db.requests, initialData: null),
          StreamProvider<List<History>>.value(value: DatabaseService.db.getHistory(authUser.uid), initialData: null),
          StreamProvider<List<AccountData>>.value(value: DatabaseService.db.users, initialData: null),
          StreamProvider<List<AppNotification>>.value(value: DatabaseService.db.getNotifications(authUser.uid), initialData: null),
        ],
        child: MainWrapper(account: authUser),
      );
    } else {
      return LoginPage();
    }
  }
}

