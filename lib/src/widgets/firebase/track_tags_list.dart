
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';

class TrackTagsList extends StatelessWidget {

  final String id;
  TrackTagsList(this.id);

  @override
  Widget build(BuildContext context) => FirebaseState((store) => TagChipList(
      tags: store.trackToTags[id],
      onRemoveTag: (x) => store.removeTags([id].toSet(), [x].toSet()),
      onAddTag: (x) => store.addTags([id].toSet(), [x].toSet()),
    )
  );
}