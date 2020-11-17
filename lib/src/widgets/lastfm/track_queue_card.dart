
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TrackQueueCard extends StatelessWidget {

  final QueueEntry<Track> entry;
  TrackQueueCard(this.entry);

  String get trackArtistName => entry.data.artist.name ?? entry.data.artist.text;

  Widget _getCard(BuildContext context) => CustomCard(
    constraints: BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: (){},
    color: entry.data.nowPlaying ? Colors.blueAccent : Colors.black12,
    child: Row(
      children: [
        if (entry.data.images.isNotEmpty) Expanded(
            child: Image.network(entry.data.images[0].text,
              height: 50,
              width: 50,
            )
        ),
        Expanded(child: Text(entry.data.name)),
        Expanded(child: Text(trackArtistName)),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: entry.processed ?
              MaterialStateProperty.all<Color>(Colors.green) :
              MaterialStateProperty.all<Color>(Colors.blueAccent),
          ),
          child: entry.processed ? Icon(Icons.check) : Icon(Icons.clear),
          onPressed: () => Provider.of<LastFmStore>(context, listen: false)
              .removeTrackFromQueue(entry),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => _getCard(context);
}