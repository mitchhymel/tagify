
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/tags/tags_list_item.dart';

class TagsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => PaginatedDesktopListView(
      pageSize: 25,
      itemCount: store.tagToTracks.length,
      fetchMore: (page, limit) => store.tagsFetch(page, limit: limit),
      onRefresh: () => store.tagsRefresh(),
      itemBuilder: (___, index) => TagsListItem(
        store.tagToTracks.keys.toList()[index],
        store.tagToTracks.values.toList()[index].length,
      ),
      hasMore: store.tagsHasMore,
    )
  );
}