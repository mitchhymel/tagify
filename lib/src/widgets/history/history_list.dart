
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/history_store.dart';
import 'package:tagify/src/widgets/common/paginated_desktop_listview.dart';
import 'package:tagify/src/widgets/history/history_list_item.dart';

class HistoryList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<HistoryStore>(
    builder: (_, store, __) => PaginatedDesktopListView(
      pageSize: 25,
      itemCount: store.recents.length,
      fetchMore: (page, pageLimit) => store.fetchAndAddToRecents(page, pageLimit),
      onRefresh: () => store.refreshRecents(),
      additionalPageCheck: 1, // recents returns the nowplaying track
      itemBuilder: (___, index) => HistoryListItem(store.recents[index]),
      hasMore: store.hasMore,
    )
  );
}
