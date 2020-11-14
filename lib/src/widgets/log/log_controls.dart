
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class LogControls extends StatelessWidget {

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Row(
      children: [
        ElevatedButton(
          child: Icon(Icons.copy),
          onPressed: () async {
            await Provider.of<LogStore>(context, listen: false).copyToClipboard();
            Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blueAccent,
              action: SnackBarAction(
                label: 'dismiss',
                textColor: Colors.white,
                onPressed: () {},
              ),
              content: Text('Log content copied to clipboard',
                  style: TextStyle(
                    color: Colors.white,
                  )
              ),
            ));
          },
        ),
        Flexible(child: Container()),
        ElevatedButton(
          child: Icon(Icons.delete),
          onPressed: () => Provider.of<LogStore>(context, listen: false).clear(),
        ),
      ],
    )
  );
}