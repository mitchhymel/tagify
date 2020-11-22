
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/history/history_list.dart';
import 'package:tagify/src/widgets/history/now_playing_card.dart';

class HistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Column(
        children: [
          NowPlayingCard(),
          Consumer<LastFmStore>(
            builder: (_, store, __) => CustomLoadingIndicator(store.recentsFetching),
          ),
          Expanded(
            child: HistoryList(),
          )
        ],
      ),
      Positioned(
        right: 10,
        bottom: 10,
        child: Consumer<LastFmStore>(
          builder: (_, store, __) => FloatingActionButton(
            onPressed: store.recentsRefresh,
            child: Icon(Icons.refresh),
          )
        )
      )
    ],
  );
}