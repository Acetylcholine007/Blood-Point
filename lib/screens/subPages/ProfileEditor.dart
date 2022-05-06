import 'package:blood_point/services/DatabaseService.dart';
import 'package:flutter/material.dart';

import '../../models/AccountData.dart';
import '../../shared/constants.dart';
import '../../shared/decorations.dart';

class ProfileEditor extends StatefulWidget {
  final AccountData account;

  const ProfileEditor(this.account, {Key key}) : super(key: key);

  @override
  _ProfileEditorState createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  AccountData account;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  void submitHandler() async {
    if(_formKey.currentState.validate()) {
      setState(() => loading = true);
      String result = await DatabaseService.db.editAccount(account);
      if(result == 'SUCCESS') {
        setState(() {
          loading = false;
        });
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Profile Edited'),
          action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          error = result;
          loading = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Edit Account'),
              content: Text(error),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
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
        content: Text('Fill up all the fields'),
        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    setState(() {
      account = widget.account;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
                initialValue: account.fullName,
                decoration: formFieldDecoration.copyWith(hintText: 'Full Name'),
                validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                onChanged: (val) => setState(() => account.fullName = val)
            ),
            SizedBox(height: 10),
            TextFormField(
                initialValue: account.username,
                decoration: formFieldDecoration.copyWith(hintText: 'Username'),
                validator: (val) => val.isEmpty ? 'Enter Username' : null,
                onChanged: (val) => setState(() => account.username = val)
            ),
            SizedBox(height: 10),
            TextFormField(
                initialValue: account.address,
                decoration: formFieldDecoration.copyWith(hintText: 'Address'),
                validator: (val) => val.isEmpty ? 'Enter Address' : null,
                onChanged: (val) => setState(() => account.address = val)
            ),
            SizedBox(height: 10),
            TextFormField(
                initialValue: account.contactNo,
                decoration: formFieldDecoration.copyWith(hintText: 'Contact No'),
                validator: (val) => val.isEmpty ? 'Enter Contact No' : val.length != 11 ? 'Phone number length should only be 11' : null,
                onChanged: (val) => setState(() => account.contactNo = val)
            ),
            SizedBox(height: 10),
            TextFormField(
              enableInteractiveSelection: false,
              onTap: (){
                FocusScope.of(context).requestFocus(new FocusNode());
                showDatePicker(
                  context: context,
                  initialDate: DateTime(DateTime.now().year - 4),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(DateTime.now().year - 4),
                ).then((pickedDate) {
                  if (pickedDate == null) {
                    return;
                  }
                  setState(() {
                    account.birthday = pickedDate;
                  });
                });
              },
              initialValue: dateFormatter.format(account.birthday),
              decoration: formFieldDecoration.copyWith(hintText: 'Birthday', suffixIcon: Icon(Icons.calendar_today_rounded)),
              validator: (val) => val.isEmpty ? 'Enter Birthday' : null,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(flex: 6, child: DropdownButtonFormField(
                value: account.bloodType,
                decoration: dropdownDecoration.copyWith(prefixIcon: Icon(Icons.bloodtype_rounded)),
                items: bloodTypes.asMap().entries.map((filter) => DropdownMenuItem(
                  value: filter.value,
                  child: Text(filter.value, overflow: TextOverflow.ellipsis),
                )).toList(),
                onChanged: (value) => setState(() => account.bloodType = value),
              )),
                SizedBox(width: 10),
                Expanded(flex: 4, child: Text('Set as donor')),
                Expanded(flex: 2, child: Switch(value: account.isDonor, onChanged: (val) => setState(() => account.isDonor = val)))
              ],
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 1,
              height: 25,
              color: theme.primaryColorDark,
            ),
            ElevatedButton(
              child: Text('Save Changes'),
              onPressed: submitHandler,
              style: formButtonDecoration,
            )
          ],
        ),
      ),
    );
  }
}
