
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TrackQueueCard extends StatelessWidget {

  final TrackCacheKey cacheKey;
  TrackQueueCard(this.cacheKey);

  Widget _getCard({
    @required BuildContext context,
    @required TrackCacheEntry entry,
    @required bool processed
  }) {

    bool hasImage = entry.imageUrl != null && entry.imageUrl != '';

    return CustomCard(
      constraints: BoxConstraints(
        maxWidth: 800,
        maxHeight: 300,
      ),
      onTap: (){},
      child: Row(
        children: [
          // if (hasImage) Expanded(
          //   child: Image.network(entry.imageUrl,
          //     height: 50,
          //     width: 50,
          //   )
          // ),
          Expanded(child: Text(entry.name,)),
          Expanded(child: Text(entry.artist,)),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: processed ?
              MaterialStateProperty.all<Color>(Colors.green) :
              MaterialStateProperty.all<Color>(Colors.blueAccent),
            ),
            child: processed ? Icon(Icons.check) : Icon(Icons.clear),
            onPressed: () => Provider.of<LastFmStore>(context, listen: false)
              .removeTrackFromQueue(entry.key),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => _getCard(
      context: context,
      entry: store.trackCache[cacheKey],
      processed: store.trackQueue.containsKey(cacheKey) ?
        store.trackQueue[cacheKey] : false,
    ),
  );
}