
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/tags/tags_list_item.dart';

class TagsList extends StatelessWidget {

  final Axis scrollDirection;
  TagsList({this.scrollDirection=Axis.vertical});

  @override
  Widget build(BuildContext context) => FirebaseState((store) => DesktopListView(
      scrollDirection: scrollDirection,
      itemCount: store.filteredTags.length,
      itemBuilder: (___, index) => TagsListItem(
        store.filteredTags[index],
        store.tagToTracks[store.filteredTags[index]].length,
      ),
    )
  );
}