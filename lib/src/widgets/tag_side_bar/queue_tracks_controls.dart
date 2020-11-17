import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/queue_controls.dart';

class QueueTracksControls extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => QueueControls(
      clearQueue: store.clearQueue,
      onAddTag: store.addTrackTag,
      onRemoveTag: store.removeTrackTag,
      tags: store.trackTags,
      showProgress: store.taggingTracks,
      start: store.tagTracks,
      stop: store.stopTaggingTracks,
      progressSoFar: store.taggedSoFar,
      totalProgress: store.totalToTag,
    )
  );
}