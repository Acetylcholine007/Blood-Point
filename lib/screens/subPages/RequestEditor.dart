import 'package:blood_point/models/Request.dart';
import 'package:blood_point/shared/decorations.dart';
import 'package:flutter/material.dart';

import '../../services/DatabaseService.dart';
import '../../shared/constants.dart';

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
  String bloodType = "O+";
  DateTime deadline = DateTime.now();
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
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  SizedBox(height: 10),
                  TextFormField(
                      enableInteractiveSelection: false,
                      onTap: (){
                      FocusScope.of(context).requestFocus(new FocusNode());
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 7)),
                        lastDate: DateTime(DateTime.now().year + 1),
                      ).then((pickedDate) {
                        if (pickedDate == null) {
                          return;
                        }
                        setState(() {
                          deadline = pickedDate;
                        });
                      });
                    },
                    initialValue: dateFormatter.format(deadline),
                    decoration: formFieldDecoration.copyWith(hintText: 'Deadline', suffixIcon: Icon(Icons.calendar_today_rounded)),
                    validator: (val) => val.isEmpty ? 'Enter Deadline' : null,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    value: bloodType,
                    decoration: dropdownDecoration.copyWith(prefixIcon: Icon(Icons.bloodtype_rounded)),
                    items: bloodTypes.asMap().entries.map((filter) => DropdownMenuItem(
                      value: filter.value,
                      child: Text(filter.value, overflow: TextOverflow.ellipsis),
                    )).toList(),
                    onChanged: (value) => setState(() => bloodType = value),
                  ),
                  SizedBox(height: 10),
                  Divider(height: 25, color: theme.primaryColorDark),
                  ElevatedButton(onPressed: saveHandler, child: Text('Save'), style: formButtonDecoration)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
