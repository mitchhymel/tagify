
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/lastfm/album_card.dart';

class TagsAlbumsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
      builder: (_, store, __) => store.selectedTag == null ||
        !store.tagToAlbums.containsKey(store.selectedTag) ? Container() :
      PaginatedDesktopListView(
        onRefresh: store.tagsRefresh,
        fetchMore: (page, limit) => print('ay'),
        itemCount: store.tagToAlbums[store.selectedTag].length,
        pageSize: 25,
        itemBuilder: (___, index) => AlbumCard(
          store.tagToAlbums[store.selectedTag].toList()[index]),
        hasMore: store.tagsHasMore,
      )
  );
}