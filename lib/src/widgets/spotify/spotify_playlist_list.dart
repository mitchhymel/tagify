import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/spotify/spotify_playlist_list_item.dart';

import '../mouse_wheel_scroll_listview.dart';

class SpotifyPlaylistList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (context, store, child) => MouseWheelScrollListView(
      builder: (controller) => Scrollbar(
        child: GridView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          itemCount: store.playlists.length,
          itemBuilder: (ctx, index) => SpotifyPlaylistListItem(
            playlist: store.playlists[index],
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          )
        )
      )
    ),
  );
}