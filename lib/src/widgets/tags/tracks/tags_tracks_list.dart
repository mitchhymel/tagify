
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class TagsTracksList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final firebase = useProvider(firebaseProvider);
    return firebase.selectedTag == null ||
        !firebase.tagToTracks.containsKey(firebase.selectedTag) ? Container() :
    DesktopListView(
      itemCount: firebase.tagToTracks[firebase.selectedTag].length,
      itemBuilder: (___, index) => TrackCard(
          firebase.tagToTracks[firebase.selectedTag].toList()[index]
      ),
    );
  }
}