
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TagsControls extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var store = Provider.of<LastFmStore>(context);
    final controller = useTextEditingController(text: store.tagsFilter);
    return Consumer<LastFmStore>(
        builder: (_, store, __) => CustomCard(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.left,
                    controller: controller,
                    onChanged: (x) => store.tagsFilter = x,
                    onSubmitted: (x) => store.tagsFilter = x,
                    decoration: InputDecoration(
                      hintText: 'Filter tags'
                    ),
                  )
                ),
                ElevatedButton(
                  child: Icon(Icons.refresh),
                  onPressed: store.tagsRefresh,
                )
              ],
            )
        )
    );
  }
}