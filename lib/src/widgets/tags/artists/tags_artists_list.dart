
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/lastfm/artist_card.dart';

class TagsArtistsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
      builder: (_, store, __) => store.selectedTag == null ||
          !store.tagToArtists.containsKey(store.selectedTag)? Container() :
      PaginatedDesktopListView(
        onRefresh: store.tagsRefresh,
        fetchMore: (page, limit) => print('ay'),
        itemCount: store.tagToArtists[store.selectedTag].length,
        pageSize: 25,
        itemBuilder: (___, index) => ArtistCard(
          store.tagToArtists[store.selectedTag].toList()[index]),
        hasMore: store.tagsHasMore,
      )
  );
}