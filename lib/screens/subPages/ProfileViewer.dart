import 'package:blood_point/models/AccountData.dart';
import 'package:flutter/material.dart';

class ProfileViewer extends StatelessWidget {
  final AccountData account;

  const ProfileViewer(this.account, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Viewer'),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.account_circle_outlined, color: Colors.white),
                backgroundColor: theme.primaryColor,
              ),
              title: Text('Full Name'),
              subtitle: Text(account.fullName),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.alternate_email_rounded, color: Colors.white),
                backgroundColor: theme.primaryColor,
              ),
              title: Text('Username'),
              subtitle: Text(account.username),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.email_rounded, color: Colors.white),
                backgroundColor: theme.primaryColor,
              ),
              title: Text('Email'),
              subtitle: Text(account.email),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.location_on_rounded, color: Colors.white),
                backgroundColor: theme.primaryColor,
              ),
              title: Text('Address'),
              subtitle: Text(account.address),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.phone_rounded, color: Colors.white),
                backgroundColor: theme.primaryColor,
              ),
              title: Text('Contact Number'),
              subtitle: Text(account.contactNo),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.cake_rounded, color: Colors.white),
                backgroundColor: theme.primaryColor,
              ),
              title: Text('Age'),
              subtitle: Text('${account.age} years old'),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.bloodtype_rounded, color: Colors.white),
                backgroundColor: theme.primaryColor,
              ),
              title: Text('Blood Type'),
              subtitle: Text(account.bloodType),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
