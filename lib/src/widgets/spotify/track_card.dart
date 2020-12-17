
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/firebase/track_tags_list.dart';


class TrackCard extends HookWidget {

  final String id;
  final bool draggable;
  TrackCard(this.id, {this.draggable=false});

  _onTap(BuildContext context) {
    var store = context.read(queueProvider);
    if (!store.trackQueue.containsKey(id)) {
      store.addTrackToQueue(id);
    }
    else {
      store.removeTrackFromQueue(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final queue = useProvider(queueProvider);
    final firebase = useProvider(firebaseProvider);

    if (!firebase.trackCache.containsKey(id)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => firebase.cacheTrackById(id));
      return CustomCard(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: 300,
        ),
        color: Colors.black12,
        child: Row(
          children: [
            CircularProgressIndicator(),
            Container(width: 10, height: 100),
            Text(id),
          ],
        )
      );
    }

    if (!TrackCacheItem.idIsOnSpotify(id)) {
      return _TrackCardWidget(
        item: firebase.trackCache[id],
        nowPlaying: false,
        inQueue: false,
      );
    }

    if (draggable && Utils.isBigScreen(context)) {
      return Draggable(
        data: id,
        child: _TrackCardWidget(
          item: firebase.trackCache[id],
          nowPlaying: false,
          inQueue: queue.trackQueue.containsKey(id),
          onTap: () => _onTap(context),
        ),
        feedback: _TrackCardWidget(
          item: firebase.trackCache[id],
          nowPlaying: false,
          inQueue: queue.trackQueue.containsKey(id),
          feedback: true,
          onTap: () => _onTap(context),
        ),
      );
    }

    return _TrackCardWidget(
      item: firebase.trackCache[id],
      nowPlaying: false,
      inQueue: queue.trackQueue.containsKey(id),
      onTap: () => _onTap(context),
    );
  }

}

class _TrackCardWidget extends StatelessWidget {

  final TrackCacheItem item;
  final bool inQueue;
  final bool nowPlaying;
  final bool feedback;
  final Function onTap;
  _TrackCardWidget({
    this.item,
    this.nowPlaying = false,
    this.inQueue = false,
    this.feedback = false,
    this.onTap,
  });

  Color _getColor() => inQueue ? Colors.blueAccent :
    nowPlaying ? Colors.blueGrey :
    !item.onSpotify ? Colors.black26 : Colors.black12;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      constraints: !feedback ? null : BoxConstraints(
        maxWidth: 800,
        maxHeight: 300,
      ),
      onTap: item.onSpotify ? onTap : null,
      color: _getColor(),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if(item.imageUrl != null) Image.network(item.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
            if(item.imageUrl == null) Container(
              height: 100,
              width: 100,
              color: Colors.black26,
              child: Center(
                child: Text('No image available',
                  textAlign: TextAlign.center,
                ),
              )
            ),
            Container(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(item.name,
                    style: TextStyle(
                      fontSize: 20,
                    )
                  )),
                  Container(height: 10),
                  Expanded(child: Text(item.artist)),
                ],
              )
            ),
            Expanded(
              child:  Wrap(
                alignment: WrapAlignment.end,
                children: [
                  if (item.onSpotify)TrackTagsList(item.id),
                  if (!item.onSpotify) Text('Track not found on Spotify'),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}