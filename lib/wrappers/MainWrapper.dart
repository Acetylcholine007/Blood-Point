import 'package:badges/badges.dart';
import 'package:blood_point/components/DonationPreparation.dart';
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
import 'package:blood_point/services/DatabaseService.dart';
import 'package:blood_point/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Request.dart';

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

  void deleteHandler(String nid) async {
    String result = await DatabaseService.db.deleteNotification(nid);
    if(result == 'SUCCESS') {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Remove Notification'),
          content: Text(result),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK')
            )
          ],
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = Provider.of<AccountData>(context);
    final notifications = Provider.of<List<AppNotification>>(context);
    List<Request> requests = Provider.of<List<Request>>(context);
    final AuthService _auth = AuthService();

    int getRequestCount() {
      if(requests != null) {
        return requests.where((request) => request.uid == account.uid).length;
      }
      return 0;
    }

    int getDonationCount() {
      if(requests != null) {
        return requests.where((request) => request.donorIds.contains(account.uid) && request.finalDonor == account.uid).length;
      }
      return 0;
    }

    return account == null || notifications == null ? Loading('Loading Account Data') : Builder(
      builder: (buildContext) {
        return GestureDetector(
          onTap: () => FocusScope.of(buildContext).requestFocus(FocusNode()),
          child: Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text('FastBlood PH'),
              actions: [
                account != null ? IconButton(onPressed: () {
                  if(account.newNotifs > 0) {
                    DatabaseService.db.seenNotification(account.uid);
                  }
                  _key.currentState.openEndDrawer();
                }, icon: Badge(
                    badgeColor: Colors.indigo[800],
                    badgeContent: Text(account.newNotifs.toString(), style: TextStyle(color: Colors.white)),
                    showBadge: account.newNotifs > 0,
                    position: BadgePosition.topEnd(),
                    child: Icon(Icons.notifications_rounded)
                )) : null
              ],
            ),
            endDrawer: Drawer(
              backgroundColor: Colors.white,
              child: Column(
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
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          textColor: Colors.white,
                          title: Text(notifications.isEmpty ? '0 Notifications' : '${notifications.length} ${notifications.length > 1 ? 'Notifications' : 'Notification'}'),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: notifications.isEmpty ? NoData('No Notifications', Icons.notifications_rounded) : ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(notifications[index].heading),
                              content: notifications[index].heading.startsWith('Preparation') ? DonationPreparation(
                                  () {
                                    Navigator.of(buildContext).pop();
                                    Navigator.of(buildContext).pop();
                                    setState(() => _currentIndex = 4);
                                  }
                              ) : Text(notifications[index].body),
                              actions: [
                                TextButton(
                                    onPressed: () => deleteHandler(notifications[index].nid),
                                    child: Text('DELETE')
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('CLOSE')
                                )
                              ],
                            )
                          ),
                          child: ListTile(
                            title: Text(notifications[index].heading),
                            subtitle: Text(datetimeFormatter.format(notifications[index].datetime)),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  )
                ],
              )
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
                          'FastBlood PH',
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
                          subtitle: Text('Requests: ${getRequestCount()} • Donations: ${getDonationCount()}'),
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
