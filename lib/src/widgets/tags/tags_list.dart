
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/tags/tags_list_item.dart';

class TagsList extends StatelessWidget {

  final Axis scrollDirection;
  TagsList({this.scrollDirection=Axis.vertical});

  @override
  Widget build(BuildContext context) => Consumer<FirebaseStore>(
    builder: (_, store, __) => DesktopListView(
      scrollDirection: scrollDirection,
      itemCount: store.filteredTags.length,
      itemBuilder: (___, index) => TagsListItem(
        store.filteredTags[index],
        store.tagToTracks[store.filteredTags[index]].length,
      ),
    )
  );
}