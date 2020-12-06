
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/playlist_create_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/playlist_create/playlist_create_controls.dart';
import 'package:tagify/src/widgets/playlist_create/playlist_create_track_list.dart';
import 'package:tagify/src/widgets/spotify/spotify_account_required.dart';

class SpotifyPlaylistCreateScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => SpotifyAccountRequired(child: Column(
    children: [
      PlaylistCreateControls(),
      Container(height: 10),
      Consumer<PlaylistCreateStore>(
        builder: (_, store, __) => CustomLoadingIndicator(store.creatingPlaylist),
      ),
      Expanded(
        child: PlaylistCreateTrackList()
      ),
    ],
  ));
}