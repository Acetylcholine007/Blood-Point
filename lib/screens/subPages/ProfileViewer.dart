import 'package:blood_point/models/AccountData.dart';
import 'package:flutter/material.dart';

class ProfileViewer extends StatelessWidget {
  final AccountData account;

  const ProfileViewer(this.account, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Viewer'),
      ),
      body: Container(
        child: Text(account.fullName),
      ),
    );
  }
}
