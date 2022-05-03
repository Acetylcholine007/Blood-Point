import 'package:blood_point/models/AccountData.dart';
import 'package:flutter/material.dart';

class DonorMap extends StatelessWidget {
  final List<AccountData> accounts;

  const DonorMap(this.accounts, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Donor Map'),
    );
  }
}
