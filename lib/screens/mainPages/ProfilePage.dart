import 'package:blood_point/screens/subPages/PasswordEditor.dart';
import 'package:blood_point/screens/subPages/ProfileEditor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/AccountData.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    AccountData account = Provider.of<AccountData>(context);

    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height),
            child: SizedBox(
              height: 50.0,
              child: Material(
                elevation: 3,
                child: Container(
                  color: theme.primaryColorDark,
                  child: const TabBar(
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        text: "Profile Settings",
                      ),
                      Tab(
                        text: "Change Password",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            child: TabBarView(
              children: [
                ProfileEditor(account),
                PasswordEditor(account.uid)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
