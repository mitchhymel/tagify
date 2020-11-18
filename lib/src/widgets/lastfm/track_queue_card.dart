
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TrackQueueCard extends StatelessWidget {

  final QueueEntry<Track> entry;
  TrackQueueCard(this.entry);

  String get imageUrl => hasDataImage ? entry.data.images[0].text
      : entry.data.album.image[0].text;
  bool get hasDataImage => (entry.data.images != null &&
  entry.data.images.isNotEmpty && entry.data.images[0].text != null);
  bool get hasAlbumImage => (entry.data.album != null &&
      entry.data.album.image != null &&
      entry.data.album.image.isNotEmpty &&
      entry.data.album.image[0].text != null);
  bool get hasImage => hasDataImage || hasAlbumImage;
  String get trackArtistName => entry.data.artist.name ?? entry.data.artist.text;

  Widget _getCard(BuildContext context) => CustomCard(
    constraints: BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: (){},
    child: Row(
      children: [
        if (hasImage) Expanded(
          child: Image.network(imageUrl,
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