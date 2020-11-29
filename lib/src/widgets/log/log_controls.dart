
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class LogControls extends HookWidget {

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<LogStore>(context);
    var controller = useTextEditingController(text: store.filter);
    return CustomCard(
        child: Row(
          children: [
            Consumer<LogStore>(
              builder: (_, store, __) => Expanded(
                child: CheckboxListTile(
                  title: Text('Only show errors'),
                  value: store.onlyShowErrors,
                  onChanged: (v) => store.onlyShowErrors = v,
                ),
              )
            ),
            Consumer<LogStore>(
              builder: (_, store, __) => Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (x) => store.filter = x,
                  decoration: InputDecoration(
                    hintText: 'Filter messages by a string'
                  ),
                )
              )
            ),
            ElevatedButton(
              child: Icon(Icons.copy),
              onPressed: () async {
                await Provider.of<LogStore>(context, listen: false).copyToClipboard();
                Utils.showSnackBar(context, 'Log content copied to clipboard');
              },
            ),
            Container(width: 5),
            ElevatedButton(
              child: Icon(Icons.delete),
              onPressed: () => Provider.of<LogStore>(context, listen: false).clear(),
            ),
          ],
        )
    );
  }
}