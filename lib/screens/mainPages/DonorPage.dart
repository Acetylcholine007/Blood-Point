import 'package:blood_point/components/DonorList.dart';
import 'package:blood_point/components/DonorMap.dart';
import 'package:blood_point/components/Loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/AccountData.dart';

class DonorPage extends StatefulWidget {
  const DonorPage({Key key}) : super(key: key);

  @override
  _DonorPageState createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    AccountData account = Provider.of<AccountData>(context);
    List<AccountData> accounts = Provider.of<List<AccountData>>(context);
    
    return accounts != null ? DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
          Size.fromHeight(MediaQuery.of(context).size.height),
          child: SizedBox(
            height: 50.0,
            child: Material(
              elevation: 3,
              child: Container(
                color: theme.primaryColorDark,
                child: const TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      text: "LIST VIEW",
                    ),
                    Tab(
                      text: "MAP VIEW",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            DonorList(accounts),
            DonorMap(accounts)
          ],
        ),
      ),
    ) : Loading('Loading Donors');
  }
}
