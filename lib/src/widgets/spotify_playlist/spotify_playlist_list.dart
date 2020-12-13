import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_playlist_list_item.dart';


class SpotifyPlaylistList extends StatelessWidget {

  final Axis scrollDirection;
  SpotifyPlaylistList({this.scrollDirection=Axis.vertical});

  @override
  Widget build(BuildContext context) => SpotifyState((store) => DesktopListView(
      scrollDirection: scrollDirection,
      itemCount: store.playlists.length,
      columns: 1,
      itemBuilder: (ctx, index) => SpotifyPlaylistListItem(
        playlist: store.playlists[index],
      ),
    ),
  );
}