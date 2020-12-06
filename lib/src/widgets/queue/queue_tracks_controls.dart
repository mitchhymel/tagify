import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/queue_store.dart';
import 'package:tagify/src/widgets/common/queue_controls.dart';

class QueueTracksControls extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer2<QueueStore, FirebaseStore>(
    builder: (_, queue, firebase, __) => QueueControls(
      clearQueue: queue.clearQueue,
      onAddTag: queue.addTagToTagList,
      onRemoveTag: queue.removeTagFromTagList,
      tags: queue.tagsToTagTracksWith,
      showProgress: queue.tagging,
      progressSoFar: queue.taggedSoFar,
      totalProgress: queue.totalToTag,
      start: () => queue.startTagging(true, firebase.updateTags),
      startRemove: () => queue.startTagging(false, firebase.updateTags),
    )
  );
}