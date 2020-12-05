
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TagsControls extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var store = Provider.of<FirebaseStore>(context);
    final controller = useTextEditingController(text: store.tagsFilter);
    return Consumer<FirebaseStore>(
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
          ],
        )
      )
    );
  }
}