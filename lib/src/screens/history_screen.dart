
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/history/history_list.dart';
import 'package:tagify/src/widgets/history/now_playing_card.dart';

class HistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          NowPlayingCard(),
          Consumer<LastFmStore>(
            builder: (_, store, __) => ElevatedButton(
              child: Icon(Icons.refresh),
              onPressed: store.recentsRefresh,
            )
          ),
          Container(width: 5),
        ],
      ),
      Consumer<LastFmStore>(
        builder: (_, store, __) => CustomLoadingIndicator(store.recentsFetching),
      ),
      Expanded(
        child: HistoryList(),
      )
    ],
  );
}