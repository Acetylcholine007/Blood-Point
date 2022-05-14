import 'package:flutter/material.dart';

class DonationPreparation extends StatelessWidget {
  final Function redirect;

  const DonationPreparation(this.redirect, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          minLeadingWidth : 0,
          leading: CircleAvatar(child: Text('1'), radius: 12),
          title: Text('Schedule an appointment at your own convenience'),
          subtitle: Text('Select a donation type and find a convenient time that works best for you.'),
        ),
        ListTile(
          minLeadingWidth : 0,
          leading: CircleAvatar(child: Text('2'), radius: 12),
          title: Text('Eat fiber-rich food'),
          subtitle: Text('Have iron-rich foods, such as red meat, fish, poultry, beans, spinach, iron-fortified cereals, or raisins.'),
        ),
        ListTile(
          minLeadingWidth : 0,
          leading: CircleAvatar(child: Text('3'), radius: 12),
          title: Text('Take a good rest and hydrate'),
          subtitle: Text('Get a good night\'s sleep the night before your donation, eat healthy foods and drink extra liquids.'),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: redirect,
          child: Text('Tap to redirect to Help Page for more information')
        ),
        SizedBox(height: 10),
        Text('Source: National Voluntary Blood Services Program (NVBSP)', style: theme.textTheme.caption.copyWith(fontStyle: FontStyle.italic))
      ],
    );
  }
}
