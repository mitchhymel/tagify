
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/history/history_list.dart';
import 'package:tagify/src/widgets/history/now_playing_card.dart';

class HistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => Column(
      children: [
        NowPlayingCard(),
        Expanded(
          child: HistoryList(),
        )
      ],
    ),
  );
}