
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/history_store.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/history/history_list.dart';
import 'package:tagify/src/widgets/spotify/spotify_account_required.dart';

class HistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => SpotifyAccountRequired(child: Stack(
    children: [
      Column(
        children: [
          Consumer<HistoryStore>(
            builder: (_, store, __) => CustomLoadingIndicator(store.recentsFetching),
          ),
          Consumer3<HistoryStore, SpotifyStore, FirebaseStore>(
            builder: (_, history, spotify, firebase, __) =>
            history.recents.length == 0 && !history.recentsFetching ?
            ElevatedButton(
              child: Text('No recent tracks fetched or found, try refreshing by clicking me'),
              onPressed: () => history.fetch(0, spotify.getHistory, firebase.addAllToCache),
            ) : Container()
          ),
          Expanded(
            child: HistoryList(),
          )
        ],
      ),
      Positioned(
        right: 10,
        bottom: 10,
        child: Consumer3<HistoryStore, SpotifyStore, FirebaseStore>(
          builder: (_, history, spotify, firebase, __) => FloatingActionButton(
            onPressed: () => history.fetch(0, spotify.getHistory, firebase.addAllToCache),
            child: Icon(Icons.refresh),
          )
        )
      )
    ],
  ));
}