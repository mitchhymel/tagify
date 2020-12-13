
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class LogControls extends HookWidget {

  @override
  Widget build(BuildContext context) {
    var log = useProvider(logProvider);
    var controller = useTextEditingController(text: log.filter);
    return CustomCard(
        child: Row(
          children: [
            LogState((store) => Expanded(
              child: CheckboxListTile(
                title: Text('Only show errors'),
                value: store.onlyShowErrors,
                onChanged: (v) => store.onlyShowErrors = v,
              ),
            )),
            LogState((store) => Expanded(
              child: TextField(
                controller: controller,
                onChanged: (x) => store.filter = x,
                decoration: InputDecoration(
                  hintText: 'Filter messages by a string'
                ),
              )
            )),
            LogState((store) => ElevatedButton(
              child: Icon(Icons.copy),
              onPressed: () async {
                await store.copyToClipboard();
                Utils.showSnackBar(context, 'Log content copied to clipboard');
              },
            )),
            Container(width: 5),
            LogState((store) =>  ElevatedButton(
              child: Icon(Icons.delete),
              onPressed: () => store.clear(),
            )),
          ],
        )
    );
  }
}