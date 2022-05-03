import 'package:flutter/material.dart';

import '../../services/AuthService.dart';
import '../../shared/decorations.dart';

class PasswordEditor extends StatefulWidget {
  const PasswordEditor({Key key}) : super(key: key);

  @override
  _PasswordEditorState createState() => _PasswordEditorState();
}

class _PasswordEditorState extends State<PasswordEditor> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String password = '';
  String confirmPassword = '';
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool loading = false;
  String error = '';

  void submitHandler() async {
    if(_formKey.currentState.validate() && confirmPassword == password) {
      setState(() => loading = true);
      String result = await _auth.changePassword(password);
      if(result == 'SUCCESS') {
        setState(() {
          loading = false;
        });
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Password Edited'),
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
              title: Text('Change Password'),
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
        content: Text('Fill up all the fields correctly'),
        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: password,
                decoration: formFieldDecoration.copyWith(suffixIcon: IconButton(
                    onPressed: () => setState(() => showPassword = !showPassword),
                    icon: Icon(Icons.visibility)
                ),
                    hintText: 'New Password'
                ),
                validator: (val) => val.isEmpty ? 'Enter New Password' : null,
                onChanged: (val) => setState(() => password = val),
                obscureText: !showPassword,
              ),
              TextFormField(
                initialValue: confirmPassword,
                decoration: formFieldDecoration.copyWith(suffixIcon: IconButton(
                    onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
                    icon: Icon(Icons.visibility)
                ),
                    hintText: 'Confirm Password'
                ),
                validator: (val) => val.isEmpty ? 'Enter Confirm Password' : null,
                onChanged: (val) => setState(() => confirmPassword = val),
                obscureText: !showConfirmPassword,
              ),
              Divider(
                thickness: 2,
                height: 25
              ),
              ElevatedButton(
                child: Text('Save Changes'),
                onPressed: submitHandler
              )
            ],
          ),
        ),
      ),
    );
  }
}
