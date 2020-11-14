
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/history_store.dart';
import 'package:tagify/src/widgets/history/history_list_item.dart';

class NowPlayingCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<HistoryStore>(
    builder: (_, store, __) => store.nowPlaying == null ? Container() :
      HistoryListItem(store.nowPlaying)
  );
}