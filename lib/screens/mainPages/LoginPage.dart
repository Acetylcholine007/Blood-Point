import 'package:blood_point/screens/mainPages/SignupPage.dart';
import 'package:flutter/material.dart';

import '../../services/AuthService.dart';
import '../../shared/decorations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  bool showPassword = true;
  bool loading = false;
  String error = '';

  void submitHandler() async {
    if(_formKey.currentState.validate()) {
      setState(() => loading = true);
      String result = await _auth.signInEmail(email, password);
      if (result != 'SUCCESS') {
        setState(() {
          error = result;
          loading = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Log In'),
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
          title: Text('Login'),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                TextButton(
                  child: Text('Forgot Password'),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage())),
                ),
                Divider(
                  thickness: 2,
                  height: 25
                ),
                ElevatedButton(
                  child: Text('LOGIN'),
                  onPressed: submitHandler,
                ),
                ElevatedButton(
                  child: Text('CREATE ACCOUNT'),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage())),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
