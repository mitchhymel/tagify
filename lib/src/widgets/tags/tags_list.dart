
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/tags/tags_list_item.dart';

class TagsList extends StatelessWidget {

  final Axis scrollDirection;
  TagsList({this.scrollDirection=Axis.vertical});

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => DesktopListView(
      scrollDirection: scrollDirection,
      itemCount: store.tagToTracks.length,
      itemBuilder: (___, index) => TagsListItem(
        store.tagToTracks.keys.toList()[index],
        store.tagToTracks.values.toList()[index].length,
      ),
    )
  );
}