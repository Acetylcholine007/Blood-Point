import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:blood_point/wrappers/AuthWrapper.dart';
import 'package:blood_point/models/Account.dart';
import 'package:blood_point/services/AuthService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
          providers: [
            StreamProvider<Account>.value(initialData: null, value: AuthService().user),
          ],
          child: MaterialApp(
            theme: appTheme,
            home: MyApp()
          )
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthWrapper();
  }
}

ThemeData appTheme = ThemeData(
  primarySwatch: Colors.red
);