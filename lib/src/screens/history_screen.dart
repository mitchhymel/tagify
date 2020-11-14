

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {


  Widget _getWidget(RecentTracksResult track) => Card(
    color: track.attr != null ? Colors.blueAccent : Colors.black12,
    child: Row(
      children: [
        Expanded(child: Image.network(track.image[0].text,
          height: 50,
          width: 50,
        )),
        Expanded(child: Text(track.name)),
        Expanded(child: Text(track.artist.text)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (ctx, store, chld) => RefreshIndicator(
      onRefresh: () => store.refreshRecents(),
      child: ListView.builder(
        itemCount: store.recents.length,
        itemBuilder: (ct, index) {
          if (index + 1 >= store.recents.length) {

            int page = (store.recents.length / 25).ceil();

            return RaisedButton(
              child: Text('Load more'),
              onPressed: () => store.fetchAndAddToRecents(page, 25),
            );
          }

          return _getWidget(store.recents[index]);
        },
      )
    ),
  );
}