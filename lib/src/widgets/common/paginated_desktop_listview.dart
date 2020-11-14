
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

  PaginatedDesktopListView({
    @required this.onRefresh,
    @required this.itemCount,
    @required this.itemBuilder,
    @required this.fetchMore,
    @required this.pageSize,
    this.additionalPageCheck=0,
  });

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: DesktopListView(
      itemCount: itemCount,
      itemBuilder: (_, index) {
        if (index + 1 >= itemCount) {

          int page = ((itemCount + additionalPageCheck) / pageSize).ceil();

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