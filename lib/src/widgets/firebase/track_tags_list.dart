
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';

class TrackTagsList extends StatelessWidget {

  final String id;
  TrackTagsList(this.id);

  @override
  Widget build(BuildContext context) => Consumer<FirebaseStore>(
    builder: (_, store, __) => TagChipList(
      tags: store.trackToTags[id],
      onRemoveTag: (x) => store.removeTags([id].toSet(), [x].toSet()),
      onAddTag: (x) => store.addTags([id].toSet(), [x].toSet()),
    )
  );
}