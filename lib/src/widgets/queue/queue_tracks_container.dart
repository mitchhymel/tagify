import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/common/drag_drop_wrappers.dart';
import 'package:tagify/src/widgets/queue/queue_tracks_controls.dart';
import 'package:tagify/src/widgets/queue/track_queue_card.dart';

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
          child: QueueState((store) => DesktopListView(
            scrollPercent: store.tagging ?
              (store.taggedSoFar / store.totalToTag) : 1,
            itemCount: store.totalToTag,
            itemBuilder: (___, index) => TrackQueueCard(
              store.trackQueue.keys.toList()[index],
            ),
          ))
        )
      ],
    )
  );
}