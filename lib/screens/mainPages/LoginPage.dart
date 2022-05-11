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
  final _formKey2 = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  bool showPassword = true;
  bool loading = false;
  String error = '';
  String resetEmail = "";

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

    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: email,
                decoration: formFieldDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter Email' : null,
                onChanged: (val) => setState(() => email = val)
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
              Divider(
                thickness: 1,
                height: 25,
                color: theme.primaryColorDark,
              ),
              ElevatedButton(
                child: Text('LOGIN'),
                onPressed: submitHandler,
                style: formButtonDecoration,
              ),
              TextButton(
                child: Text('Forgot Password?'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Reset Password'),
                        content: Form(
                          key: _formKey2,
                          child: TextFormField(
                              initialValue: resetEmail,
                              decoration: formFieldDecoration.copyWith(hintText: 'Email'),
                              validator: (val) => val.isEmpty ? 'Enter Email' : null,
                              onChanged: (val) => setState(() => resetEmail = val)
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                if (_formKey2.currentState.validate()) {
                                  String result = await _auth.resetPassword(resetEmail);
                                  if (result == 'SUCCESS') {
                                    Navigator.pop(context);
                                    final snackBar = SnackBar(
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text('Password Reset sent to your email.'),
                                      action: SnackBarAction(label: 'OK',
                                          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  } else {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              title: Text('Reset Password'),
                                              content: Text(result),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('OK')
                                                )
                                              ],
                                            )
                                    );
                                  }
                                }
                              },
                              child: Text('RESET PASSWORD')
                          )
                        ],
                      )
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
