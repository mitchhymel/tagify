
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';


class TrackTagsList extends StatelessWidget {

  final TrackCacheKey cacheKey;
  TrackTagsList(this.cacheKey);

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => TagChipList(
      tags: store.trackToTags[cacheKey],
      onRemoveTag: (x) => store.removeTagFromTrack(cacheKey, x),
      onAddTag: (x) => store.addTagsToTrack(cacheKey, [x].toSet()),
    )
  );
}