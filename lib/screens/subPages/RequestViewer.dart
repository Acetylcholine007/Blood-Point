import 'package:blood_point/models/Request.dart';
import 'package:flutter/material.dart';

import '../../models/AccountData.dart';

class RequestViewer extends StatefulWidget {
  final Request request;
  final AccountData account;

  const RequestViewer(this.request, {Key key, this.account}) : super(key: key);

  @override
  _RequestViewerState createState() => _RequestViewerState();
}

class _RequestViewerState extends State<RequestViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Viewer'),
      ),
      body: Container(
        child: Text(widget.request.bloodType),
      ),
    );
  }
}
