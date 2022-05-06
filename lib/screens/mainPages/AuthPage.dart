import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(20),
            child: Card(

              child: Column(
                children: [
                  ToggleButtons(
                    children: [
                      Text('LOGIN'),
                      Text('SIGNUP'),
                    ],
                    onPressed: (index) => {},
                    isSelected: [true, false],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
