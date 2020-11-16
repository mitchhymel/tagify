
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TagsTracksListItem extends StatelessWidget {

  final Track track;
  TagsTracksListItem(this.track);

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Row(
      children: [
        Expanded(child: Image.network(track.images[0].text,
          height: 50,
          width: 50,
        )),
        Expanded(child: Text(track.name)),
        Expanded(child: Text(track.artist.name)),
      ],
    ),
  );
}