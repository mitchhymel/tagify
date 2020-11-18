
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/lastfm/track_card.dart';

class SearchTracksList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => PaginatedDesktopListView(
      onRefresh: store.searchRefresh,
      fetchMore: (page, limit) => store.searchTrack(page, limit: limit),
      itemCount: store.searchTracks.length,
      pageSize: 25,
      itemBuilder: (___, index) => TrackCard(new TrackCacheEntry(
        track: store.searchTracks[index],
        tags: []
      )),
      hasMore: store.searchHasMore,
    )
  );
}