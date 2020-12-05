
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class TagsTracksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<FirebaseStore>(
    builder: (_, firebase, __) => firebase.selectedTag == null ||
      !firebase.tagToTracks.containsKey(firebase.selectedTag) ? Container() :
    DesktopListView(
      itemCount: firebase.tagToTracks[firebase.selectedTag].length,
      itemBuilder: (___, index) => TrackCard(
        firebase.tagToTracks[firebase.selectedTag].toList()[index]
      ),
    )
  );
}