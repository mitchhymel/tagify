import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';

class LogContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LogStore>(
    builder: (_, store, child) => DesktopListView(
      itemCount: store.lines.length,
      itemBuilder: (__, index) => SelectableText.rich(
        TextSpan(
          text: store.lines[index].time.toString(),
          style: TextStyle(
            color: Colors.redAccent,
          ),
          children: [
            TextSpan(
                text: ' :: ${store.lines[index].line}',
                style: TextStyle(
                    color: Colors.white
                )
            )
          ]
        )
      )
    ),
  );
}