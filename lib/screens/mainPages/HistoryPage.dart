import 'package:blood_point/components/Loading.dart';
import 'package:blood_point/components/NoData.dart';
import 'package:blood_point/models/History.dart';
import 'package:blood_point/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/DatabaseService.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  CircleAvatar iconSelector(String heading) {
    if(heading.startsWith('Account')) {
      return CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(Icons.account_circle_outlined),
      );
    } else if(heading.startsWith('Request')) {
      return CircleAvatar(
        backgroundColor: Colors.deepOrangeAccent,
        child: Icon(Icons.assignment_rounded),
      );
    } else if(heading.startsWith('Don')) {
      return CircleAvatar(
        backgroundColor: Colors.purpleAccent,
        child: Icon(Icons.handshake_rounded),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.limeAccent,
        child: Icon(Icons.category_rounded),
      );
    }
  }

  void deleteHandler(String hid) async {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Remove History'),
        content: Text('Do you really want to delete this history?'),
        actions: [
          TextButton(onPressed: () async {
            Navigator.of(context).pop();
            String result = await DatabaseService.db.deleteHistory(hid);
            if(result == 'SUCCESS') {
              Navigator.pop(context);
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Remove History'),
                    content: Text(result),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK')
                      )
                    ],
                  )
              );
            }
          }, child: Text('Yes')),
          TextButton(onPressed: () async {
            Navigator.of(context).pop();
          }, child: Text('No'))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<History> history = Provider.of<List<History>>(context);

    return history != null ? history.isNotEmpty ? Container(
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () =>
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(history[index].heading),
                  content: Text(history[index].body),
                  actions: [
                    TextButton(
                        onPressed: () => deleteHandler(history[index].hid),
                        child: Text('DELETE')
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('CLOSE')
                    )
                  ],
                )
              ),
            child: ListTile(
              leading: iconSelector(history[index].heading),
              title: Text(history[index].heading),
              subtitle: Text(datetimeFormatter.format(history[index].datetime)),
            ),
          );
        },
      ),
    ) : NoData('No History') : Loading('Loading History');
  }
}
