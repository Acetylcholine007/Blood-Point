import 'package:blood_point/components/Loading.dart';
import 'package:blood_point/models/Account.dart';
import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/screens/mainPages/DonorPage.dart';
import 'package:blood_point/screens/mainPages/FeedPage.dart';
import 'package:blood_point/screens/mainPages/HomePage.dart';
import 'package:blood_point/screens/mainPages/ProfilePage.dart';
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
        ProfilePage()
      )
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = Provider.of<AccountData>(context);

    return account == null ? Loading('Loading Account Data') : Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
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
                      children: const [
                        Text(
                          'Blood Point',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Home', style: TextStyle(color: Colors.white)),
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                  ListTile(
                    title: Text('Feeds', style: TextStyle(color: Colors.white)),
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                  ListTile(
                      title: Text('Donors', style: TextStyle(color: Colors.white)),
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                  ListTile(
                    title: Text('Profile', style: TextStyle(color: Colors.white)),
                    onTap: () => setState(() => _currentIndex = 3),
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
