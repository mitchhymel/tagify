
import 'dart:io';

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

  Widget _getCard(BuildContext context, {bool feedback=false}) => CustomCard(
    constraints: !feedback ? null : BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: !draggable ? (){} : () {
      bool success = Provider.of<LastFmStore>(context, listen: false)
          .addTrackToQueue(track);
      if (success && !Platform.isWindows) {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blueAccent,
          action: SnackBarAction(
            label: 'dismiss',
            textColor: Colors.white,
            onPressed: () {},
          ),
          content: Text('Added "${track.name}" by "$trackArtistName" to track tag queue',
            style: TextStyle(
              color: Colors.white,
            )
          ),
        ));
      }
    },
    color: track.nowPlaying ? Colors.blueGrey : Colors.black12,
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
  Widget build(BuildContext context) => (draggable && Platform.isWindows) ?
  Draggable(
    data: track,
    feedback: _getCard(context, feedback: true),
    child: _getCard(context)
  ) : _getCard(context);
}