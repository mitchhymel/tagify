
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TrackCard extends StatelessWidget {

  final Track track;
  TrackCard(this.track);

  String get trackArtistName => track.artist.name ?? track.artist.text;

  Widget _getCard() => CustomCard(
    constraints: BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: () {},
    color: track.nowPlaying ? Colors.blueAccent : Colors.black12,
    child: Row(
      children: [
        if (track.images.isNotEmpty) Expanded(
          child: Image.network(track.images[0].text,
            height: 50,
            width: 50,
          )
        ),
        Expanded(child: Text(track.name)),
        Expanded(child: Text(trackArtistName)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Draggable(
    data: track,
    feedback: _getCard(),
    child: _getCard()
  );
}