
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/cache_store.dart';
import 'package:tagify/src/state/search_store.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class SearchTracksControls extends HookWidget {

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<SearchStore>(context);
    final trackController = useTextEditingController(text: store.query);

    return Consumer3<SpotifyStore, SearchStore, CacheStore>(
      builder: (_, spotify, search, cache, __) => CustomCard(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: trackController,
                onChanged: (x) => search.query = x,
                onSubmitted: (x) => search.search(spotify.search, cache.addAllToCache),
                decoration: InputDecoration(
                  hintText: 'Search by track name',
                )
              )
            ),
          ],
        ),
      )
    );
  }
}