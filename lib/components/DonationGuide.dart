import 'package:flutter/material.dart';

class DonationGuide extends StatelessWidget {
  const DonationGuide({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text('Basic requirements of a potential blood donor:', style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.normal)),
        ListTile(
          title: Text('•	Weight: At least 110 lbs (50 kg).'),
        ),
        ListTile(
          title: Text('•	Blood volume collected will depend mainly on you body weight.'),
        ),
        ListTile(
          title: Text('•	Pulse rate: Between 60 and 100 beats/minute with regular rhythm.'),
        ),
        ListTile(
          title: Text('•	Blood pressure: Between 90 and 160 systolic and 60 and 100 diastolic.'),
        ),
        ListTile(
          title: Text('•	Hemoglobin: At least 125 g/L.'),
        ),
        Text('Source: National Voluntary Blood Services Program (NVBSP)', style: theme.textTheme.caption)
      ],
    );
  }
}
