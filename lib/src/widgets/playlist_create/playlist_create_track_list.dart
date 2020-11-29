
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/lastfm/track_card.dart';

class PlaylistCreateTrackList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => store.playlistTracks.length == 0 ? Container() :
    DesktopListView(
      itemCount: store.playlistTracks.length,
      itemBuilder: (___, index) => TrackCard(
        store.playlistTracks.toList()[index],
        draggable: false,
        // child: Text('${store.tracks.toList()[index].name} by ${store.tracks.toList()[index].artist}'),
      )
    )
  );
}