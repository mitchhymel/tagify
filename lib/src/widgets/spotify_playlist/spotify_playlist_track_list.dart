
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class SpotifyPlaylistTrackList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, __) => store.selectedPlaylist == null ||
      !store.playlistIdToTracks.containsKey(store.selectedPlaylist.id) ? Container() :
      DesktopListView(
        itemCount: store.playlistIdToTracks[store.selectedPlaylist.id].length,
        itemBuilder: (___, index) => TrackCard(
          store.playlistIdToTracks[store.selectedPlaylist.id][index],
          draggable: true,
        ),
      )
  );
}