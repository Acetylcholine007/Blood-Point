import 'package:blood_point/components/NoData.dart';
import 'package:blood_point/models/Request.dart';
import 'package:blood_point/screens/subPages/ProfileViewer.dart';
import 'package:blood_point/screens/subPages/RequestEditor.dart';
import 'package:flutter/material.dart';

import '../../models/AccountData.dart';
import '../../services/DatabaseService.dart';

class RequestViewer extends StatefulWidget {
  final Request request;
  final AccountData account;
  final String myUid;

  const RequestViewer(this.request, {Key key, this.account, this.myUid}) : super(key: key);

  @override
  _RequestViewerState createState() => _RequestViewerState();
}

class _RequestViewerState extends State<RequestViewer> {
  void donateHandler() async {

  }

  void terminateHandler() async {

  }

  void deleteHandler() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Viewer'),
        actions: widget.myUid == widget.request.uid ? [
          IconButton(onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestEditor(isNew: false, request: widget.request, uid: widget.myUid)),
          ), icon: Icon(Icons.edit)),
          IconButton(onPressed: terminateHandler, icon: Icon(Icons.cancel_rounded)),
          IconButton(onPressed: deleteHandler, icon: Icon(Icons.delete_forever_rounded)),
        ] : [
          IconButton(onPressed: donateHandler, icon: Icon(Icons.check_box))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Text(widget.account.fullName)
            ),
            Expanded(
                flex: 1,
                child: Text(widget.account.email)
            ),
            Expanded(
                flex: 1,
                child: Text(widget.account.contactNo)
            ),
            Expanded(
                flex: 1,
                child: Text(widget.account.address)
            ),
            Expanded(
                flex: 1,
                child: Text('Looking for ${widget.request.bloodType} blood type donation')
            ),
            Expanded(
                flex: 1,
                child: Text(widget.request.message)
            ),
            Divider(),
            Expanded(
                flex: 1,
                child: Text('Willing Donors')
            ),
            Expanded(
                flex: 8,
                child: widget.request.donorIds.isNotEmpty ? SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: widget.request.donorIds.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder<AccountData>(
                          future: DatabaseService.db.getAccount(widget.request.donorIds[index]),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.done) {
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProfileViewer(snapshot.data)),
                                ),
                                child: ListTile(
                                  leading: Text('${index + 1}'),
                                  title: LinearProgressIndicator(),
                                  subtitle: LinearProgressIndicator(),
                                ),
                              );
                            } else {
                              return ListTile(
                                leading: Text('${index + 1}'),
                                title: Text(snapshot.data.fullName),
                                subtitle: Text(snapshot.data.email),
                              );
                            }
                          }
                      );
                    }
                  ),
                ) : NoData('No willing donors yet')
            ),
          ],
        ),
      ),
    );
  }
}
