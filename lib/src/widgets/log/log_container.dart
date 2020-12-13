import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';

class LogContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) => LogState(
    (store) => DesktopListView(
      itemCount: store.lines.length,
      itemBuilder: (__, index) => SelectableText.rich(
        TextSpan(
          text: store.lines[index].time.toString(),
          style: TextStyle(
            color: store.lines[index].isError ? Colors.redAccent : Colors.blueAccent,
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