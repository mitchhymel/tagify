
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/playlist_create_store.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/playlist_create/playlist_create_controls.dart';
import 'package:tagify/src/widgets/playlist_create/playlist_create_track_list.dart';
import 'package:tagify/src/widgets/settings/spotify_account_widget.dart';

class SpotifyPlaylistCreateScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer2<SpotifyStore, PlaylistCreateStore>(
      builder: (_, spotify, playlist, __) => !spotify.loggedIn ? SpotifyAccountWidget() :
      Column(
        children: [
          PlaylistCreateControls(),
          Container(height: 10),
          CustomLoadingIndicator(playlist.creatingPlaylist),
          Expanded(
            child: PlaylistCreateTrackList()
          ),
        ],
      )
  );
}