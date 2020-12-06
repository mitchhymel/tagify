
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/playlist_create_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class PlaylistCreateTrackList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var pc = Provider.of<PlaylistCreateStore>(context);
    var fb = Provider.of<FirebaseStore>(context);
    var tracks = pc.getTracks(fb.tagToTracks, fb.trackToTags);

    return Consumer<PlaylistCreateStore>(
        builder: (_, store, __) => tracks.length == 0 ? Container() :
        DesktopListView(
            itemCount: tracks.length,
            itemBuilder: (___, index) => TrackCard(
              tracks[index],
              draggable: false,
            )
        )
    );
  }
}