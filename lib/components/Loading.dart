import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final String title;

  Loading(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitChasingDots(
                color: theme.primaryColor,
                size: 50
            ),
            SizedBox(height: 50),
            Text(title, style: theme.textTheme.headline6),
          ],
        ),
      ),
    );
  }
}
