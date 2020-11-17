
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'file:///E:/Dev/Flutter/MyProjects/tagify/lib/src/widgets/lastfm/track_card.dart';

class NowPlayingCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => store.nowPlaying == null ? Container() :
      TrackCard(store.nowPlaying)
  );
}