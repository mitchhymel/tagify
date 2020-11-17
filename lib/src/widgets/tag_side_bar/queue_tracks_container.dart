import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/common/drag_drop_wrappers.dart';
import 'package:tagify/src/widgets/lastfm/track_queue_card.dart';
import 'package:tagify/src/widgets/tag_side_bar/queue_tracks_controls.dart';

class QueueTracksContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) => WrapDropTargetTrack(
    child: Column(
      children: [
        Flexible(
          flex: 2,
          child: QueueTracksControls()
        ),
        Flexible(
          flex: 5,
          child: Consumer<LastFmStore>(
            builder: (_, store, __) => DesktopListView(
              itemCount: store.queuedTracks.length,
              itemBuilder: (___, index) => TrackQueueCard(
                store.queuedTracks[index],
              ),
            )
          )
        )
      ],
    )
  );
}