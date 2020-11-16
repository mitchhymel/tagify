
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/tags_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/tags/tracks/tags_tracks_list_item.dart';

class TagsTracksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<TagsStore>(
      builder: (_, store, __) => store.selectedResult == null ? Container() :
      PaginatedDesktopListView(
        onRefresh: store.refresh,
        fetchMore: (page, limit) => print('ay'),
        itemCount: store.selectedResult.tracks.length,
        pageSize: 25,
        itemBuilder: (___, index) => TagsTracksListItem(store.selectedResult.tracks[index]),
        hasMore: store.hasMore,
      )
  );
}