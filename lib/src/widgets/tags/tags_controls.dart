
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TagsControls extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var store = useProvider(firebaseProvider);
    final controller = useTextEditingController(text: store.tagsFilter);
    return CustomCard(
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
    );
  }
}