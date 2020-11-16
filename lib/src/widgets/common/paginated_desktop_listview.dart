
import 'package:flutter/material.dart';

import 'package:tagify/src/widgets/common/desktop_listview.dart';

typedef FetchPageRequest = void Function(int, int);

class PaginatedDesktopListView extends StatelessWidget {

  final VoidCallback onRefresh;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final FetchPageRequest fetchMore;
  final int pageSize;
  final int additionalPageCheck;
  final bool hasMore;

  PaginatedDesktopListView({
    @required this.onRefresh,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.fetchMore,
    @required this.pageSize,
    @required this.hasMore,
    this.additionalPageCheck=0,
  });

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: DesktopListView(
      itemCount: itemCount,
      itemBuilder: (_, index) {
        if (index + 1 >= itemCount && hasMore) {

          int page = ((1 + itemCount + additionalPageCheck) / pageSize).ceil();

          return RaisedButton(
            child: Text('Load more'),
            onPressed: () => fetchMore(page, pageSize),
          );
        }

        return itemBuilder(_, index);
      },

    ),
  );
}