
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/custom_text_field.dart';

class TagsControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => CustomCard(
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              initialText: store.tagsFilter,
              hint: 'Filter tags',
              onChanged: (x) => store.tagsFilter = x,
              onSubmitted: (x) => store.tagsFilter = x,
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