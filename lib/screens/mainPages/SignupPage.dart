import 'package:flutter/material.dart';

import '../../models/AccountData.dart';
import '../../services/AuthService.dart';
import '../../shared/decorations.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String fullName = '';
  String username = '';
  String address = '';
  String contactNo = '';
  String bloodType = 'O';
  double latitude = 14;
  double longitude = 120;
  bool isDonor = false;
  bool showPassword = true;
  bool loading = false;
  String error = '';

  void submitHandler() async {
    if(_formKey.currentState.validate()) {
      setState(() => loading = true);
      String result = await _auth.register(
          AccountData(
            fullName: this.fullName,
            username: this.username,
            address: this.address,
            contactNo: this.contactNo,
            bloodType: this.bloodType,
            isDonor: this.isDonor,
            latitude: this.latitude,
            longitude: this.longitude
          ),
          email,
          password
      );
      if(result == 'SUCCESS') {
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          error = result;
          loading = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sign In'),
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: fullName,
                      decoration: formFieldDecoration.copyWith(hintText: 'Full Name'),
                      validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                      onChanged: (val) => setState(() => fullName = val)
                    ),
                    TextFormField(
                      initialValue: username,
                      decoration: formFieldDecoration.copyWith(hintText: 'Username'),
                      validator: (val) => val.isEmpty ? 'Enter Username' : null,
                      onChanged: (val) => setState(() => username = val)
                    ),
                    TextFormField(
                      initialValue: address,
                      decoration: formFieldDecoration.copyWith(hintText: 'Address'),
                      validator: (val) => val.isEmpty ? 'Enter Address' : null,
                      onChanged: (val) => setState(() => address = val)
                    ),
                    TextFormField(
                        initialValue: contactNo,
                        decoration: formFieldDecoration.copyWith(hintText: 'Contact No'),
                        validator: (val) => val.isEmpty ? 'Enter Contact No' : null,
                        onChanged: (val) => setState(() => contactNo = val)
                    ),
                    TextFormField(
                      initialValue: email,
                      decoration: formFieldDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter Email' : null,
                      onChanged: (val) => setState(() => email = val)
                    ),
                    TextFormField(
                      initialValue: password,
                      decoration: formFieldDecoration.copyWith(suffixIcon: IconButton(
                          onPressed: () => setState(() => showPassword = !showPassword),
                          icon: Icon(Icons.visibility)
                      ),
                          hintText: 'Password'
                      ),
                      validator: (val) => val.isEmpty ? 'Enter Password' : null,
                      onChanged: (val) => setState(() => password = val),
                      obscureText: showPassword,
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
                    Switch(value: isDonor, onChanged: (val) => setState(() => isDonor = val)),
                    Divider(
                        thickness: 2,
                        height: 25
                    ),
                    ElevatedButton(
                      child: Text('SIGN UP'),
                      onPressed: submitHandler
                    ),
                    ElevatedButton(
                      child: Text('LOGIN'),
                      onPressed: () => Navigator.pop(context)
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
