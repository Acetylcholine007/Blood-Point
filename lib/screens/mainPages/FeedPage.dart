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

    return Scaffold(
      body: requests != null ? requests.isEmpty ? NoData('No Requests') : Container(
        child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<AccountData>(
                  future: DatabaseService.db.getAccount(requests[index].uid),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RequestViewer(requests[index], account: snapshot.data)),
                        ),
                        child: RequestTile(requests[index], account: snapshot.data),
                      );
                    } else {
                      return RequestTile(requests[index]);
                    }
                  }
              );
            }
        ),
      ) : Loading('Loading Requests'),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RequestEditor(isNew: true, uid: account.uid)),
        ),
      ),
    );
  }
}
