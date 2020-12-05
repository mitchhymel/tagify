
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/cache_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/firebase/track_tags_list.dart';

class TrackCard extends StatelessWidget {

  final String id;
  final bool draggable;
  TrackCard(this.id, {this.draggable=true});

  _onTap(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) => Consumer<CacheStore>(
    builder: (_, store, __) => draggable && Utils.isBigScreen(context) ?
      Draggable(
        data: id,
        child: _TrackCardWidget(
          item: store.trackCache[id],
          nowPlaying: false,
          inQueue: false,
          onTap: !draggable ? (){} : () => _onTap(context),
        ),
        feedback: _TrackCardWidget(
          item: store.trackCache[id],
          nowPlaying: false,
          inQueue: false,
          feedback: true,
          onTap: !draggable ? (){} : () => _onTap(context),
        ),
      ) :
      _TrackCardWidget(
        item: store.trackCache[id],
        nowPlaying: false,
        inQueue: false,
        onTap: !draggable ? (){} : () => _onTap(context),
      ),
  );

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
    nowPlaying ? Colors.blueGrey : Colors.black12;

  @override
  Widget build(BuildContext context) => CustomCard(
    constraints: !feedback ? null : BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: onTap,
    color: _getColor(),
    child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(item.imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.fill,
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
              children: [
                TrackTagsList(item.id),
              ],
            ),
          )
        ],
      ),
    )
  );
}