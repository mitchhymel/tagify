import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/queue_controls.dart';

class QueueTracksControls extends HookWidget {

  @override
  Widget build(BuildContext context) {
    final queue = useProvider(queueProvider);
    final firebase = useProvider(firebaseProvider);
    return QueueControls(
      clearQueue: queue.clearQueue,
      onAddTag: queue.addTagToTagList,
      onRemoveTag: queue.removeTagFromTagList,
      tags: queue.tagsToTagTracksWith,
      showProgress: queue.tagging,
      progressSoFar: queue.taggedSoFar,
      totalProgress: queue.totalToTag,
      start: () => queue.startTagging(true, firebase.updateTags),
      startRemove: () => queue.startTagging(false, firebase.updateTags),
    );
  }
}