
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/custom_text_field.dart';

class SearchTracksControls extends HookWidget {

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<LastFmStore>(context);
    final trackController = useTextEditingController(text: store.trackQuery);
    final artistController = useTextEditingController(text: store.artistQuery);

    return Consumer<LastFmStore>(
      builder: (_, store, __) => CustomCard(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: trackController,
                onChanged: (x) => store.trackQuery = x,
                onSubmitted: (x) => store.searchRefresh(),
                decoration: InputDecoration(
                  hintText: 'Search by track name',
                )
              )
            ),
            Container(width: 10),
            Expanded(
              child: TextField(
                controller: artistController,
                onChanged: (x) => store.artistQuery = x,
                onSubmitted: (x) => store.searchRefresh(),
                decoration: InputDecoration(
                  hintText: 'Optionally, include artist name for track',
                ),
              )
            )
          ],
        ),
      )
    );
  }
}