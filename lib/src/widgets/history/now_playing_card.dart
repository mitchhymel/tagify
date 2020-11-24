
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/lastfm/track_card.dart';

class NowPlayingCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => store.nowPlaying == null ? Container() :
      Stack(
        children: [
          TrackCard(store.nowPlaying),
          Positioned(
            left: 0,
            top: .5,
            child: Icon(Icons.star)
          )
        ],
      )
  );
}