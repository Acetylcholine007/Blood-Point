import 'package:blood_point/models/AccountData.dart';
import 'package:flutter/material.dart';

import '../models/Request.dart';

class RequestTile extends StatelessWidget {
  final Request request;
  final AccountData account;

  const RequestTile(this.request, {Key key, this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 150,
      child: Card(
        color: theme.primaryColorLight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: Center(child: Text(request.bloodType, style: theme.textTheme.headline2)),
              ),
              Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 2,
                            child: account == null ? LinearProgressIndicator() :
                            Text(account.fullName, style: theme.textTheme.headline4.copyWith(fontSize: 30), overflow: TextOverflow.ellipsis)
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(request.message, style: theme.textTheme.bodyText1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}