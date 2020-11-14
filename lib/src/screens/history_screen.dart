
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/history_store.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/history/history_list.dart';
import 'package:tagify/src/widgets/history/now_playing_card.dart';

class HistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      NowPlayingCard(),
      Consumer<HistoryStore>(
        builder: (_, store, __) => CustomLoadingIndicator(store.fetching),
      ),
      Expanded(
        child: HistoryList(),
      )
    ],
  );
}