import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/spotify/spotify_account_required.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_filter_playlists_controls.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_playlist_list.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_playlist_track_list.dart';

class SpotifyPlaylistsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => SpotifyAccountRequired(
    child: Stack(
      children: [
        if(!Utils.isBigScreen(context)) Column(
          children: [
            SpotifyFilterPlaylistsControls(),
            PlaylistFetchLoadingIndicator(),
            Container(
              constraints: BoxConstraints(
                maxHeight: 100,
              ),
              child: SpotifyPlaylistList(scrollDirection: Axis.horizontal,)
            ),
            Container(height: 10),
            Expanded(
              child: SpotifyPlaylistTrackList(),
            )
          ],
        ),
        if (Utils.isBigScreen(context)) Row(
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
                  PlaylistFetchLoadingIndicator(),
                  Expanded(
                    child: SpotifyPlaylistTrackList(),
                  )
                ]
              )
            )
          ],
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Consumer(builder: (_, watch, __) => FloatingActionButton(
            onPressed: watch(spotifyProvider).refreshPlaylists,
            child: Icon(Icons.refresh),
          ))
        )
      ],
    )
  );
}