import 'package:blood_point/components/Loading.dart';
import 'package:blood_point/components/NoData.dart';
import 'package:blood_point/models/Request.dart';
import 'package:blood_point/screens/subPages/RequestEditor.dart';
import 'package:blood_point/screens/subPages/RequestViewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/RequestTile.dart';
import '../../models/AccountData.dart';
import '../../services/DatabaseService.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    AccountData account = Provider.of<AccountData>(context);
    List<Request> requests = Provider.of<List<Request>>(context);
    List<Request> myRequest = requests != null ? requests.where((item) => item.uid == account.uid).toList() : [];
    List<Request> myDonations = requests != null ? requests.where((item) => item.donorIds.contains(account.uid)).toList() : [];

    return DefaultTabController(
      length: 3,
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
                      text: "All Requests",
                    ),
                    Tab(
                      text: "My Requests",
                    ),
                    Tab(
                      text: "My Donations",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: requests != null ? Container(
          padding: EdgeInsets.all(16),
          child: TabBarView(
            children: [
              requests.isEmpty ? NoData('No Requests', Icons.dynamic_feed_rounded) : ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<AccountData>(
                        future: DatabaseService.db.getAccount(requests[index].uid),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.done) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RequestViewer(requests[index], account: snapshot.data, myUid: account.uid, myBloodType: account.bloodType, myAccount: account, myName: account.fullName)),
                              ),
                              child: RequestTile(requests[index], account: snapshot.data, myAccount: account),
                            );
                          } else {
                            return RequestTile(requests[index], myAccount: account);
                          }
                        }
                    );
                  }
              ),
              myRequest.isEmpty ? NoData('No Requests', Icons.dynamic_feed_rounded) : ListView.builder(
                  itemCount: myRequest.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<AccountData>(
                        future: DatabaseService.db.getAccount(myRequest[index].uid),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.done) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RequestViewer(myRequest[index], account: snapshot.data, myUid: account.uid, myBloodType: account.bloodType, myAccount: account, myName: account.fullName)),
                              ),
                              child: RequestTile(myRequest[index], account: snapshot.data, myAccount: account),
                            );
                          } else {
                            return RequestTile(myRequest[index], myAccount: account);
                          }
                        }
                    );
                  }
              ),
              myDonations.isEmpty ? NoData('No Donations', Icons.bloodtype_rounded) : ListView.builder(
                  itemCount: myDonations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<AccountData>(
                        future: DatabaseService.db.getAccount(myDonations[index].uid),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.done) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RequestViewer(myDonations[index], account: snapshot.data, myUid: account.uid, myBloodType: account.bloodType, myAccount: account, isDonation: true, myName: account.fullName)),
                              ),
                              child: RequestTile(myDonations[index], account: snapshot.data, myAccount: account, forDonation: true),
                            );
                          } else {
                            return RequestTile(myDonations[index], myAccount: account, forDonation: true);
                          }
                        }
                    );
                  }
              )
            ],
          ),
        ) : Loading('Loading Requests'),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestEditor(isNew: true, uid: account.uid)),
          ),
        ),
      ),
    );
  }
}
