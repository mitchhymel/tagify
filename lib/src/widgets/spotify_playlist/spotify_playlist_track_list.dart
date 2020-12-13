
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class SpotifyPlaylistTrackList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SpotifyState((store) =>
  store.selectedPlaylist == null ||
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