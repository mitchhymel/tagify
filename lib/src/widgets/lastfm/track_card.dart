
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TrackCard extends StatelessWidget {

  final bool draggable;
  final Track track;
  TrackCard(this.track, {this.draggable = true});

  String get trackArtistName => track.artist.name ?? track.artist.text;

  Widget _getCard(BuildContext context) => CustomCard(
    constraints: BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: !draggable ? (){} :
        () => Provider.of<LastFmStore>(context, listen: false)
            .addTrackToQueue(track),
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
  Widget build(BuildContext context) => !draggable ? _getCard(context) : Draggable(
    data: track,
    feedback: _getCard(context),
    child: _getCard(context)
  );
}