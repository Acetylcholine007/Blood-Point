import 'package:blood_point/components/Loading.dart';
import 'package:blood_point/models/Account.dart';
import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/screens/mainPages/DonorPage.dart';
import 'package:blood_point/screens/mainPages/FeedPage.dart';
import 'package:blood_point/screens/mainPages/HistoryPage.dart';
import 'package:blood_point/screens/mainPages/HomePage.dart';
import 'package:blood_point/screens/mainPages/ProfilePage.dart';
import 'package:blood_point/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatefulWidget {
  final Account account;

  MainWrapper({this.account});

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;
  List<Page> pages;

  @override
  void initState() {
    pages = [
      Page(
        HomePage()
      ),
      Page(
        FeedPage()
      ),
      Page(
        DonorPage()
      ),
      Page(
        HistoryPage()
      ),
      Page(
        ProfilePage()
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = Provider.of<AccountData>(context);
    final AuthService _auth = AuthService();

    return account == null ? Loading('Loading Account Data') : Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Blood Point'),
              actions: [
                IconButton(onPressed: () => {}, icon: Icon(Icons.notifications_rounded))
              ],
            ),
            drawer: Drawer(
              backgroundColor: theme.primaryColorDark.withOpacity(0.60),
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: theme.primaryColorDark,
                    ),
                    margin: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Blood Point',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          textColor: Colors.white,
                          leading: CircleAvatar(
                            child: Text(account.bloodType, style: theme.textTheme.headline5),
                            backgroundColor: Colors.white,
                          ),
                          title: Text(account.fullName),
                          subtitle: Text(account.email),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    selected: _currentIndex == 0,
                    iconColor: Colors.white,
                    leading: Icon(Icons.home_rounded),
                    title: Text('Home', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  ListTile(
                    selected: _currentIndex == 1,
                    iconColor: Colors.white,
                    leading: Icon(Icons.dynamic_feed_rounded),
                    title: Text('Feeds', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _currentIndex = 1);
                    },
                  ),
                  ListTile(
                    selected: _currentIndex == 2,
                    iconColor: Colors.white,
                    leading: Icon(Icons.people_rounded),
                      title: Text('Donors', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _currentIndex = 2);
                    },
                  ),
                  ListTile(
                    selected: _currentIndex == 3,
                    iconColor: Colors.white,
                    leading: Icon(Icons.history_rounded),
                    title: Text('History', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _currentIndex = 3);
                    },
                  ),
                  ListTile(
                    selected: _currentIndex == 4,
                    iconColor: Colors.white,
                    leading: Icon(Icons.account_circle_outlined),
                    title: Text('Profile', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _currentIndex = 4);
                    },
                  ),
                  Divider(color: Colors.white),
                  ListTile(
                    iconColor: Colors.white,
                    leading: Icon(Icons.logout),
                    title: Text('Sign Out', style: TextStyle(color: Colors.white)),
                    onTap: () => _auth.signOut(),
                  )
                ],
              ),
            ),
            body: Container(
                child: pages[_currentIndex].page
            )
          ),
        );
      },
    );
  }
}

class Page {
  Widget page;

  Page(this.page);
}
