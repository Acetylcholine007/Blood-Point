import 'package:blood_point/components/NoData.dart';
import 'package:blood_point/models/Request.dart';
import 'package:blood_point/screens/subPages/MapPage.dart';
import 'package:blood_point/screens/subPages/ProfileViewer.dart';
import 'package:blood_point/screens/subPages/RequestEditor.dart';
import 'package:blood_point/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/DonationGuide.dart';
import '../../models/AccountData.dart';
import '../../services/DatabaseService.dart';

class RequestViewer extends StatefulWidget {
  final Request request;
  final AccountData account;
  final String myUid;
  final String myBloodType;
  final AccountData myAccount;
  final bool isDonation;

  const RequestViewer(this.request, {Key key, this.isDonation = false, this.account, this.myUid, this.myBloodType, this.myAccount}) : super(key: key);

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
    if(widget.request.bloodType == widget.myBloodType) {
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
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(isDonor() ? 'Retract Donation Offer' : 'File Donation Offer'),
            content: Text('Your blood type is not compatible to what the seeker is requesting'),
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
          ElevatedButton.icon(
            icon: isDonor() ? Icon(Icons.cancel_rounded) : Icon(Icons.volunteer_activism),
            onPressed: donateHandler,
            label: Text(isDonor() ? 'Retract Offer' : 'Offer Donation'),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: CircleAvatar(child: Icon(Icons.person_rounded, size: 40), radius: 40)),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.account.fullName, style: theme.textTheme.headline5, textAlign: TextAlign.center),
                ]
              ),
            ),
            Divider(height: 25, color: theme.primaryColorDark),
            Text('Date Requested: ${datetimeFormatter.format(request.datetime)}', style: theme.textTheme.bodyText1),
            SizedBox(height: 10),
            Text('Request Deadline: ${datetimeFormatter.format(request.deadline)}', style: theme.textTheme.bodyText1),
            Divider(height: 25, color: theme.primaryColorDark),
            Text('Information', style: theme.textTheme.headline5),
            SizedBox(height: 10),
            Row(children: [
              Expanded(flex: 1, child: ElevatedButton.icon(onPressed: () => launch("mailto:${widget.account.email}"), icon:  Icon(Icons.email_rounded), label: Text('Mail'))),
              SizedBox(width: 10),
              Expanded(flex: 3, child: Text(widget.account.email, style: theme.textTheme.bodyText1)),
            ]),
            SizedBox(height: 10),
            Row(children: [
              Expanded(flex: 1, child: ElevatedButton.icon(onPressed: () => launch("tel://${widget.account.contactNo}"), icon:  Icon(Icons.phone_rounded), label: Text('Call'))),
              SizedBox(width: 10),
              Expanded(flex: 3, child: Text(widget.account.contactNo, style: theme.textTheme.bodyText1)),
            ]),
            SizedBox(height: 10),
            Row(children: [
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage(
                    LatLng(widget.myAccount.latitude, widget.myAccount.longitude),
                    LatLng(widget.account.latitude, widget.account.longitude)
                  )),
                ), icon:  Icon(Icons.location_on_rounded), label: Text('Find')),
              ),
              SizedBox(width: 10),
              Expanded(flex: 3, child: Text(widget.account.address, style: theme.textTheme.bodyText1)),
            ]),
            Divider(height: 25, color: theme.primaryColorDark),
            Text('Looking for ${request.bloodType} blood type donation', style: theme.textTheme.bodyText1),
            SizedBox(height: 10),
            Text(request.message, style: theme.textTheme.bodyText2, maxLines: 3, overflow: TextOverflow.ellipsis),
            Divider(height: 25, color: theme.primaryColorDark),
            Text(widget.isDonation ? 'Donation Guide' : 'Willing Donors', style: theme.textTheme.headline5),
            // widget.isDonation ? null : SizedBox(height: 10),
            widget.isDonation ? DonationGuide() :Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: SizedBox(
                  height: 180,
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
                                  MaterialPageRoute(builder: (context) => ProfileViewer(snapshot.data, widget.myAccount)),
                                ),
                                child: Card(
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
                                ),
                              );
                            } else {
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text('${index + 1}', style: theme.textTheme.headline6.copyWith(color: Colors.white)),
                                    backgroundColor: theme.primaryColor,
                                  ),
                                  title: LinearProgressIndicator(),
                                  subtitle: LinearProgressIndicator(),
                                ),
                              );
                            }
                          }
                      );
                    }
                  ) : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: theme.primaryColorDark
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0)
                      ),
                    ),
                      child: NoData('No willing donors yet', Icons.bloodtype_rounded)
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
