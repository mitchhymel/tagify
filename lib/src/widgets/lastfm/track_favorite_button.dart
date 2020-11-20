
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/models.dart';

class TrackFavoriteButton extends StatelessWidget {

  final TrackCacheKey cacheKey;
  TrackFavoriteButton(this.cacheKey);

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => IconButton(
      icon: store.trackCache[cacheKey].track.userloved ?
        Icon(Icons.favorite, color: Colors.redAccent) : Icon(Icons.favorite_outline),
      onPressed: () => store.changeLikeOnTrack(cacheKey, !store.trackCache[cacheKey].track.userloved),
    )
  );
}