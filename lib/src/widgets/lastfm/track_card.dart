
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/lastfm/track_favorite_button.dart';
import 'package:tagify/src/widgets/lastfm/track_tags_list.dart';

class TrackCard extends StatelessWidget {

  final TrackCacheKey cacheKey;
  final bool draggable;
  TrackCard(this.cacheKey, {
    this.draggable = true,
  });

  void _onTap(BuildContext context) {
    var store = Provider.of<LastFmStore>(context, listen: false);
    bool success = false;
    String str = '';
    if (store.trackQueue.containsKey(cacheKey)) {
      store.removeTrackFromQueue(cacheKey);
      success = true;
      str = 'Removed ${cacheKey.toLogStr()} from track tag queue';
    }
    else {
      success = store.addTrackToQueue(cacheKey);
      str = 'Added ${cacheKey.toLogStr()} to track tag queue';
    }
    if (success && !Utils.isBigScreen(context)) {
      Utils.showSnackBar(context, str);
    }
  }

  Widget _getCard(BuildContext context, TrackCacheEntry entry, {
    bool feedback=false
  }) {

    bool hasImage = Utils.stringIsNotNullOrEmpty(entry.imageUrl);
    bool nowPlaying = Provider.of<LastFmStore>(context).nowPlaying == cacheKey;
    bool isInQueue = Provider.of<LastFmStore>(context).trackQueue.containsKey(cacheKey);

    return CustomCard(
        constraints: !feedback ? null : BoxConstraints(
          maxWidth: 800,
          maxHeight: 300,
        ),
        onTap: !draggable ? (){} : () => _onTap(context),
        color: isInQueue ? Colors.blueAccent : nowPlaying ? Colors.blueGrey : Colors.black12,
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (hasImage) Image.network(entry.imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                  if (!hasImage) Container(
                    height: 100,
                    width: 100,
                  ),
                  Container(width: 10),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(entry.name,
                              style: TextStyle(
                                fontSize: 20,
                              )
                          )),
                          Container(height: 10),
                          Expanded(child: Text(entry.artist)),
                        ],
                      )
                  ),
                  Expanded(
                    child:  Wrap(
                      children: [
                        TrackTagsList(cacheKey),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                child: TrackFavoriteButton(cacheKey),
                right: 1,
                top: 1,
              ),
              Positioned(
                child: Text('${entry.playCount == 0 ? "" : entry.playCount}'),
                right: 1,
                bottom: 1,
              )
            ],
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => (draggable && Utils.isBigScreen(context)) ?
    Draggable(
      data: cacheKey,
      feedback: _getCard(context, store.trackCache[cacheKey], feedback: true),
      child: _getCard(context, store.trackCache[cacheKey])
    ) : _getCard(context, store.trackCache[cacheKey])
  );
}