import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String title;
  final IconData icon;

  const NoData(this.title, this.icon, {Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(child: Icon(icon, size: 30), radius: 30),
          SizedBox(height: 20),
          Text(title,style: theme.textTheme.headline4),
        ],
      ),
    );
  }
}
