
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TrackQueueCard extends StatelessWidget {

  final QueueEntry<TrackCacheKey> queueEntry;
  TrackQueueCard(this.queueEntry);

  Widget _getCard(BuildContext context, TrackCacheEntry entry) {

    bool hasDataImage = (entry.track.images != null &&
        entry.track.images.isNotEmpty &&
        entry.track.images[0].text != null);
    bool hasAlbumImage = (entry.track.album != null &&
        entry.track.album.image != null &&
        entry.track.album.image.isNotEmpty &&
        entry.track.album.image[0].text != null);
    bool hasImage = hasDataImage || hasAlbumImage;
    String imageUrl = hasDataImage ? entry.track.images[0].text
        : entry.track.album.image[0].text;
    String trackArtistName = entry.track.artist.name
        ?? entry.track.artist.text;

    return CustomCard(
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
          Expanded(child: Text(entry.name)),
          Expanded(child: Text(trackArtistName)),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: queueEntry.processed ?
              MaterialStateProperty.all<Color>(Colors.green) :
              MaterialStateProperty.all<Color>(Colors.blueAccent),
            ),
            child: queueEntry.processed ? Icon(Icons.check) : Icon(Icons.clear),
            onPressed: () => Provider.of<LastFmStore>(context, listen: false)
                .removeTrackFromQueue(entry.key),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => _getCard(_, store.trackCache[queueEntry.data]),
  );
}