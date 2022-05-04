import 'package:blood_point/models/Request.dart';
import 'package:blood_point/shared/decorations.dart';
import 'package:flutter/material.dart';

import '../../services/DatabaseService.dart';

class RequestEditor extends StatefulWidget {
  final bool isNew;
  final String uid;
  final Request request;
  const RequestEditor({Key key, this.isNew, this.request, this.uid}) : super(key: key);

  @override
  _RequestEditorState createState() => _RequestEditorState();
}

class _RequestEditorState extends State<RequestEditor> {
  final _formKey = GlobalKey<FormState>();
  String rid;
  String message = "";
  String bloodType = "O";
  List<String> donorIds;
  bool isComplete;

  @override
  void initState() {
    if(widget.request != null) {
      setState(() {
        rid = widget.request.rid;
        message = widget.request.message;
        bloodType = widget.request.bloodType;
        donorIds = widget.request.donorIds;
        isComplete = widget.request.isComplete;
      });
    }
    super.initState();
  }

  void saveHandler() async {

    if(_formKey.currentState.validate()) {
      String result = '';
      if(widget.isNew) {
        Request request = Request(
          uid: widget.uid,
          message: this.message,
          bloodType: this.bloodType,
          datetime: DateTime.now()
        );
        result = await DatabaseService.db.addRequest(request, widget.uid);
      } else {
        Request request = Request(
          uid: widget.uid,
          rid: this.rid,
          message: this.message,
          bloodType: this.bloodType,
          donorIds: this.donorIds,
          isComplete: this.isComplete,
          datetime: widget.request.datetime
        );
        result = await DatabaseService.db.editRequest(request, widget.uid);
      }

      if(result == 'SUCCESS') {
        if(!widget.isNew) {
          Navigator.pop(context);
        }
        Navigator.pop(context);
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(widget.isNew ? 'Create Request' : 'Edit Request'),
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
      final snackBar = SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        content: Text('Fill up message field'),
        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isNew ? 'Create Blood Request' : 'Edit Blood Request'),
          actions: [
            IconButton(icon: Icon(Icons.save), onPressed: saveHandler)
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    initialValue: message,
                    decoration: formFieldDecoration.copyWith(hintText: 'Message'),
                    validator: (val) => val.isEmpty ? 'Enter Message' : null,
                    onChanged: (val) => setState(() {
                      message = val;
                    }),
                    maxLines: 5,
                  ),
                  DropdownButtonFormField(
                    value: bloodType,
                    decoration: dropdownDecoration.copyWith(fillColor: theme.backgroundColor),
                    items: ['A', 'B', 'AB', 'O'].asMap().entries.map((filter) => DropdownMenuItem(
                      value: filter.value,
                      child: Text(filter.value, overflow: TextOverflow.ellipsis),
                    )).toList(),
                    onChanged: (value) => setState(() => bloodType = value),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
