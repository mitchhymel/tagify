
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/lastfm/artist_card.dart';

class TagsArtistsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
      builder: (_, store, __) => store.tagsSelectedResult == null ? Container() :
      PaginatedDesktopListView(
        onRefresh: store.tagsRefresh,
        fetchMore: (page, limit) => print('ay'),
        itemCount: store.selectedTagArtists.length,
        pageSize: 25,
        itemBuilder: (___, index) => ArtistCard(
          store.selectedTagArtists[index]),
        hasMore: store.tagsHasMore,
      )
  );
}