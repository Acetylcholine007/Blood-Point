import 'package:flutter/material.dart';

class DonationGuide extends StatelessWidget {
  const DonationGuide({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Text('Basic requirements for a potential blood donor:', style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.normal)),
        ListTile(
          minLeadingWidth : 0,
          leading: CircleAvatar(child: Text('1'), radius: 12),
          title: Text('Weight: At least 110 lbs (50 kg).'),
        ),
        ListTile(
          minLeadingWidth : 0,
          leading: CircleAvatar(child: Text('2'), radius: 12),
          title: Text('Blood volume collected will depend mainly on you body weight.'),
        ),
        ListTile(
          minLeadingWidth : 0,
          leading: CircleAvatar(child: Text('3'), radius: 12),
          title: Text('Pulse rate: Between 60 and 100 beats/minute with regular rhythm.'),
        ),
        ListTile(
          minLeadingWidth : 0,
          leading: CircleAvatar(child: Text('4'), radius: 12),
          title: Text('Blood pressure: Between 90 and 160 systolic and 60 and 100 diastolic.'),
        ),
        ListTile(
          minLeadingWidth : 0,
          leading: CircleAvatar(child: Text('5'), radius: 12),
          title: Text('Hemoglobin: At least 125 g/L.'),
        ),
        Text('Source: National Voluntary Blood Services Program (NVBSP)', style: theme.textTheme.caption)
      ],
    );
  }
}
