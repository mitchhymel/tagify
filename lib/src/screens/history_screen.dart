
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/history/history_list.dart';
import 'package:tagify/src/widgets/spotify/spotify_account_required.dart';

class HistoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => SpotifyAccountRequired(child: Stack(
    children: [
      Column(
        children: [
          Consumer(builder: (_, watch, __) => CustomLoadingIndicator(
              watch(historyProvider).recentsFetching),
          ),
          Consumer(builder: (_, watch, __) {
            final history = watch(historyProvider);
            final spotify = watch(spotifyProvider);
            final firebase = watch(firebaseProvider);

            if (history.recents.length != 0 || history.recentsFetching) {
              return Container();
            }

            return ElevatedButton(
              child: Text('No recent tracks fetched or found, try refreshing by clicking me'),
              onPressed: () => history.fetch(0, spotify.getHistory, firebase.addAllToCache),
            );
          }),
          Expanded(
            child: HistoryList(),
          )
        ],
      ),
      Positioned(
        right: 10,
        bottom: 10,
        child: Consumer(builder: (_, watch, __) {
          final history = watch(historyProvider);
          final spotify = watch(spotifyProvider);
          final firebase = watch(firebaseProvider);
          return FloatingActionButton(
            onPressed: () => history.fetch(0, spotify.getHistory, firebase.addAllToCache),
            child: Icon(Icons.refresh),
          );
        })
      )
    ],
  ));
}