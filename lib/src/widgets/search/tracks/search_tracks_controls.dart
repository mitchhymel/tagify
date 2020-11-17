
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/custom_text_field.dart';

class SearchTracksControls extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => CustomCard(
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              initialText: store.trackQuery,
              hint: 'Search by track name',
              onChanged: (x) => store.trackQuery = x,
              onSubmitted: (x) => store.searchRefresh(),
            )
          ),
          Container(width: 10),
          Expanded(
            child: CustomTextField(
              initialText: store.artistQuery,
              hint: 'Optionally, include artist name for track',
              onChanged: (x) => store.artistQuery = x,
              onSubmitted: (x) => store.searchRefresh(),
            )
          )
        ],
      ),
    )
  );
}