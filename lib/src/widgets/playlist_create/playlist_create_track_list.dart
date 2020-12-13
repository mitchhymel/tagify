
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class PlaylistCreateTrackList extends HookWidget {

  @override
  Widget build(BuildContext context) {

    var pc = useProvider(playlistProvider);
    var fb = useProvider(firebaseProvider);
    var tracks = pc.getTracks(fb.tagToTracks, fb.trackToTags, fb.trackCache);

    return tracks.length == 0 ? Container() :
    DesktopListView(
      itemCount: tracks.length,
      itemBuilder: (___, index) => TrackCard(
        tracks[index],
        draggable: false,
      )
    );
  }
}