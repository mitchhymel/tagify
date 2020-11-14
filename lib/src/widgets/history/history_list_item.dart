

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class HistoryListItem extends StatelessWidget {

  final RecentTracksResult track;
  HistoryListItem(this.track);

  @override
  Widget build(BuildContext context) => CustomCard(
    color: track.nowPlaying ? Colors.blueAccent : Colors.black12,
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
}