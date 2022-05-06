import 'package:blood_point/models/AccountData.dart';
import 'package:flutter/material.dart';

import '../models/Request.dart';
import '../shared/constants.dart';

class RequestTile extends StatelessWidget {
  final Request request;
  final AccountData account;

  const RequestTile(this.request, {Key key, this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(child: Icon(Icons.bloodtype_rounded), backgroundColor: theme.primaryColor),
              title: account == null ? LinearProgressIndicator() : Text(account.fullName, style: theme.textTheme.headline6,),
              subtitle: Text(datetimeFormatter.format(request.datetime)),
            ),
            Text('Looking for: ${request.bloodType} Blood Type Donor', style: theme.textTheme.bodyText1),
            SizedBox(height: 10),
            Text('Deadline: ${dateFormatter.format(request.deadline)}', style: theme.textTheme.bodyText1),
            Divider(color: theme.primaryColorDark),
            account == null ? LinearProgressIndicator() : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(onPressed: () {}, icon: Icon(Icons.location_on_rounded), label: Text(account.address, overflow: TextOverflow.ellipsis)),
                TextButton.icon(onPressed: () {}, icon: Icon(Icons.phone_rounded), label: Text(account.contactNo))
              ],
            )
          ],
        ),
      ),
    );
  }
}