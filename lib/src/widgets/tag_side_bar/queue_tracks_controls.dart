import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/queue_controls.dart';

class QueueTracksControls extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => QueueControls(
      clearQueue: store.clearQueue,
      onAddTag: store.addTagToTagList,
      onRemoveTag: store.removeTagFromTagList,
      tags: store.tagsToTagTracksWith,
      showProgress: store.taggingTracks,
      start: store.tagTracks,
      stop: store.stopTaggingTracks,
      progressSoFar: store.taggedSoFar,
      totalProgress: store.trackQueue.length,
      startRemove: store.removeTagsFromTracks,
      stopRemove: store.stopTaggingTracks,
    )
  );
}