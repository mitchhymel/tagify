
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/lastfm/track_card.dart';

class HistoryList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => PaginatedDesktopListView(
      pageSize: 25,
      itemCount: store.recents.length,
      fetchMore: (page, pageLimit) => store.recentsFetch(page, pageLimit),
      onRefresh: () => store.recentsRefresh(),
      additionalPageCheck: 1, // recents returns the nowplaying track
      itemBuilder: (___, index) => TrackCard(store.recents[index]),
      hasMore: store.recentsHasMore,
    )
  );
}
