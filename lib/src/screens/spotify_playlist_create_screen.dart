
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
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
      Consumer(builder: (_, watch, __) =>
        CustomLoadingIndicator(watch(playlistProvider).creatingPlaylist),
      ),
      Expanded(
        child: PlaylistCreateTrackList()
      ),
    ],
  ));
}