
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/playlist_create_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';

class PlaylistCreateTrackList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<PlaylistCreateStore>(
    builder: (_, store, __) => DesktopListView(
      itemCount: store.tracks.length,
      itemBuilder: (___, index) => CustomCard(
        child: Text('${store.tracks.toList()[index].name} by ${store.tracks.toList()[index].artist}'),
      )
    )
  );
}