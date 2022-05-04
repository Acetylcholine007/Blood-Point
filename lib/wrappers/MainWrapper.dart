import 'package:blood_point/components/Loading.dart';
import 'package:blood_point/components/NoData.dart';
import 'package:blood_point/models/Account.dart';
import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/models/AppNotification.dart';
import 'package:blood_point/screens/mainPages/DonorPage.dart';
import 'package:blood_point/screens/mainPages/FeedPage.dart';
import 'package:blood_point/screens/mainPages/HelpPage.dart';
import 'package:blood_point/screens/mainPages/HistoryPage.dart';
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
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int _currentIndex = 0;
  List<Page> pages;

  @override
  void initState() {
    pages = [
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
      ),
      Page(
        HelpPage()
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = Provider.of<AccountData>(context);
    final notifications = Provider.of<List<AppNotification>>(context);
    final AuthService _auth = AuthService();

    return account == null || notifications == null ? Loading('Loading Account Data') : Builder(
      builder: (buildContext) {
        return GestureDetector(
          onTap: () => FocusScope.of(buildContext).requestFocus(FocusNode()),
          child: Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text('Blood Point'),
              actions: [
                IconButton(onPressed: () => _key.currentState.openEndDrawer(), icon: Icon(Icons.notifications_rounded))
              ],
            ),
            endDrawer: Drawer(
              backgroundColor: Colors.white,
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: theme.primaryColorDark,
                    ),
                    margin: EdgeInsets.all(0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          textColor: Colors.white,
                          title: Text(notifications.isEmpty ? 'No Notifications' : '${notifications.length} notifications'),
                        )
                      ],
                    ),
                  ),
                ] + (notifications.isEmpty ? [] :
                notifications.map((AppNotification notif) => ListTile(
                  title: Text(notif.heading),
                  subtitle: Text(notif.datetime.toString()),
                )).toList()
                ),
              ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            child: Text(account.bloodType, style: theme.textTheme.headline6),
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
                    leading: Icon(Icons.dynamic_feed_rounded),
                    title: Text('Feeds', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(buildContext).pop();
                      setState(() => _currentIndex = 0);
                    },
                  ),
                  ListTile(
                    selected: _currentIndex == 1,
                    iconColor: Colors.white,
                    leading: Icon(Icons.people_rounded),
                      title: Text('Donors', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(buildContext).pop();
                      setState(() => _currentIndex = 1);
                    },
                  ),
                  ListTile(
                    selected: _currentIndex == 2,
                    iconColor: Colors.white,
                    leading: Icon(Icons.history_rounded),
                    title: Text('History', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(buildContext).pop();
                      setState(() => _currentIndex = 2);
                    },
                  ),
                  ListTile(
                    selected: _currentIndex == 3,
                    iconColor: Colors.white,
                    leading: Icon(Icons.account_circle_outlined),
                    title: Text('Profile', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(buildContext).pop();
                      setState(() => _currentIndex = 3);
                    },
                  ),
                  ListTile(
                    selected: _currentIndex == 4,
                    iconColor: Colors.white,
                    leading: Icon(Icons.help_outline_rounded),
                    title: Text('Help', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(buildContext).pop();
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
