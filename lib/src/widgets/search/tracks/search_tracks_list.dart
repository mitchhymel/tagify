
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/search/search_tracks_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/search/tracks/search_tracks_list_item.dart';

class SearchTracksList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<SearchTracksStore>(
    builder: (_, store, __) => PaginatedDesktopListView(
      onRefresh: store.refresh,
      fetchMore: (page, limit) => store.search(page, limit: limit),
      itemCount: store.tracks.length,
      pageSize: 25,
      itemBuilder: (___, index) => SearchTracksListItem(store.tracks[index]),
      hasMore: store.hasMore,
    )
  );
}