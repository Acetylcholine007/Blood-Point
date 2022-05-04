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
  Request request;

  @override
  void initState() {
    setState(() => request = widget.request);
    super.initState();
  }

  bool isDonor() {
    return request.donorIds.contains(widget.myUid);
  }

  void donateHandler() async {
    List<String> donorIds = request.donorIds;
    if(!isDonor()) {
      donorIds.add(widget.myUid);
    } else {
      donorIds.remove(widget.myUid);
    }
    String result = await DatabaseService.db.updateDonor(widget.request.rid, donorIds, widget.myUid, widget.request.uid);
    if(result == 'SUCCESS') {
      setState(() => request.donorIds = donorIds);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(isDonor() ? 'Retract Donation Offer' : 'File Donation Offer'),
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

  void terminateHandler() async {

    String result = await DatabaseService.db.terminateRequest(request.rid, widget.myUid);
    if(result == 'SUCCESS') {
      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Terminate Request'),
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

  void setDonorHandler(String donorUid) async {
    String oldDonor = request.finalDonor;
    String finalDonor = request.finalDonor;
    if(donorUid == finalDonor) {
      finalDonor = "";
    } else {
      finalDonor = donorUid;
    }
    String result = await DatabaseService.db.setFinalDonor(request.rid, finalDonor, widget.myUid, oldDonor);
    if(result == 'SUCCESS') {
      setState(() {
        request.finalDonor = finalDonor;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Set Final Donor'),
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

  void deleteHandler() async {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Remove Request'),
        content: Text('Do you really want to delete this request?'),
        actions: [
          TextButton(onPressed: () async {
            Navigator.of(context).pop();
            String result = await DatabaseService.db.removeRequest(request.rid, widget.myUid);
            if(result == 'SUCCESS') {
              Navigator.pop(context);
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Remove Request'),
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
          }, child: Text('Yes')),
          TextButton(onPressed: () async {
            Navigator.of(context).pop();
          }, child: Text('No'))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Request Viewer'),
        actions: widget.myUid == request.uid ? [
          IconButton(onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestEditor(isNew: false, request: request, uid: widget.myUid)),
          ), icon: Icon(Icons.edit)),
          // IconButton(onPressed: terminateHandler, icon: Icon(Icons.cancel_rounded)),
          IconButton(onPressed: deleteHandler, icon: Icon(Icons.delete_rounded)),
        ] : [
          IconButton(onPressed: donateHandler, icon: isDonor() ? Icon(Icons.check_box_rounded) : Icon(Icons.check_box_outline_blank_rounded))
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Text('Looking for ${request.bloodType} blood type donation')
            ),
            Expanded(
                flex: 1,
                child: Text(request.message)
            ),
            Divider(),
            Expanded(
                flex: 1,
                child: Text('Willing Donors', style: theme.textTheme.headline6)
            ),
            Expanded(
                flex: 8,
                child: request.donorIds.isNotEmpty ? ListView.builder(
                  itemCount: request.donorIds.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<AccountData>(
                        future: DatabaseService.db.getAccount(request.donorIds[index]),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.done) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProfileViewer(snapshot.data)),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}', style: theme.textTheme.headline6.copyWith(color: Colors.white)),
                                  backgroundColor: theme.primaryColor,
                                ),
                                title: Text(snapshot.data.fullName),
                                subtitle: Text(snapshot.data.email),
                                trailing: request.uid == widget.myUid ? IconButton(
                                  onPressed: () => setDonorHandler(snapshot.data.uid),
                                  icon: snapshot.data.uid == request.finalDonor ? Icon(Icons.check_box_outlined):Icon(Icons.check_box_outline_blank_rounded),
                                ) : null,
                              ),
                            );
                          } else {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}', style: theme.textTheme.headline6.copyWith(color: Colors.white)),
                                backgroundColor: theme.primaryColor,
                              ),
                              title: LinearProgressIndicator(),
                              subtitle: LinearProgressIndicator(),
                            );
                          }
                        }
                    );
                  }
                ) : NoData('No willing donors yet')
            ),
          ],
        ),
      ),
    );
  }
}
