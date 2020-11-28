import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/settings/spotify_account_widget.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_filter_playlists_controls.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_playlist_list.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_playlist_track_list.dart';

class SpotifyPlaylistScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, __) => !store.loggedIn ? SpotifyAccountWidget() :
    Row(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            children: [
              SpotifyFilterPlaylistsControls(),
              Expanded(
                child: SpotifyPlaylistList()
              )
            ],
          )
        ),
        Flexible(
          flex: 3,
          child: Column(
            children: [
              CustomLoadingIndicator(store.fetchingPlaylist),
              Expanded(
                child: SpotifyPlaylistTrackList(),
              )
            ]
          )
        )
      ],
    )
  );
}