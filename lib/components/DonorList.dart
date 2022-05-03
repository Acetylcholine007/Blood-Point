import 'package:blood_point/components/NoData.dart';
import 'package:blood_point/models/AccountData.dart';
import 'package:blood_point/screens/subPages/ProfileViewer.dart';
import 'package:flutter/material.dart';

class DonorList extends StatelessWidget {
  final List<AccountData> accounts;

  const DonorList(this.accounts, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: accounts.isNotEmpty ? ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileViewer(accounts[index])),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}', style: theme.textTheme.headline6.copyWith(color: Colors.white)),
              ),
              title: Text(accounts[index].fullName),
              subtitle: Text(accounts[index].email),
            ),
          );
        },
      ) : NoData('No Donors available'),
    );
  }
}
