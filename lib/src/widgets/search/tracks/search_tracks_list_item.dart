
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class SearchTracksListItem extends StatelessWidget {

  final TrackSearchResult track;
  SearchTracksListItem(this.track);

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Row(
      children: [
        Text(track.name)
      ],
    )
  );
}