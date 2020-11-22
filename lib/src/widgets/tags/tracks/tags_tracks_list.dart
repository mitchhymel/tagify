
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/lastfm/track_card.dart';

class TagsTracksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
      builder: (_, store, __) => store.selectedTag == null ? Container() :
      PaginatedDesktopListView(
        onRefresh: store.tagsRefresh,
        fetchMore: (page, limit) => print('ay'),
        itemCount: store.tagToTracks[store.selectedTag].length,
        pageSize: 25,
        itemBuilder: (___, index) => TrackCard(
            store.tagToTracks[store.selectedTag].toList()[index]),
        hasMore: store.tagsHasMore,
      )
  );
}