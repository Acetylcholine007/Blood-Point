import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String title;

  const NoData(this.title, {Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Center(
        child: Text(title,style: theme.textTheme.headline4),
      ),
    );
  }
}
