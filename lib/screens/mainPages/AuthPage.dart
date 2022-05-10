import 'package:blood_point/screens/mainPages/LoginPage.dart';
import 'package:blood_point/screens/mainPages/SignupPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  List<bool> pageController = [true, false];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Colors.black
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0)
                ),
              ),
              child: Column(
                children: [
                  LayoutBuilder(builder: (context, constraints) => ToggleButtons(
                    textStyle: theme.textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold),
                    color: theme.primaryColor,
                    selectedColor: Colors.white,
                    children: [
                      Text('LOGIN'),
                      Text('SIGNUP')
                    ],
                    constraints: BoxConstraints.expand(width: constraints.maxWidth / 2 - 16, height: 40),
                    isSelected: pageController,
                    borderRadius: BorderRadius.circular(100),
                    fillColor: theme.primaryColor,
                    onPressed: (index) => setState(() {
                      List<bool> controller = [false, false];
                      controller[index] = true;
                      pageController = controller;
                    }),
                  )),
                  SizedBox(height: 20),
                  Expanded(child: pageController[0] ? LoginPage() : SignupPage())
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
