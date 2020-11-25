import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/common/drag_drop_wrappers.dart';
import 'package:tagify/src/widgets/lastfm/track_queue_card.dart';
import 'package:tagify/src/widgets/queue/queue_tracks_controls.dart';

class QueueTracksContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) => WrapDropTargetTrack(
    child: Column(
      children: [
        IntrinsicHeight(
          child: QueueTracksControls()
        ),
        Flexible(
          flex: 5,
          child: Consumer<LastFmStore>(
            builder: (_, store, __) => DesktopListView(
              scrollPercent: store.taggingTracks ?
                (store.taggedSoFar / store.totalToTag) : 1,
              itemCount: store.trackQueue.length,
              itemBuilder: (___, index) => TrackQueueCard(
                store.trackQueue.keys.toList()[index],
              ),
            )
          )
        )
      ],
    )
  );
}