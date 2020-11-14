import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_playlist_list_item.dart';


class SpotifyPlaylistList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (context, store, child) => DesktopListView(
      itemCount: store.playlists.length,
      columns: 2,
      itemBuilder: (ctx, index) => SpotifyPlaylistListItem(
        playlist: store.playlists[index],
      ),
    ),
  );
}