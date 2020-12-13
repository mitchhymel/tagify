
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TrackQueueCard extends HookWidget {

  final String id;
  TrackQueueCard(this.id);

  @override
  Widget build(BuildContext context) {
    final firebase = useProvider(firebaseProvider);
    final queue = useProvider(queueProvider);
    return _TrackQueueCardWidget(
      item: firebase.trackCache[id],
      processed: queue.trackQueue.containsKey(id) ?
        queue.trackQueue[id] : false,
      onPressed: () => queue.removeTrackFromQueue(id)
    );
  }
}

class _TrackQueueCardWidget extends StatelessWidget {

  final TrackCacheItem item;
  final bool processed;
  final Function onPressed;
  _TrackQueueCardWidget({
    @required this.item,
    @required this.processed,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => CustomCard(
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
        Expanded(child: Text(item.name,)),
        Expanded(child: Text(item.artist,)),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: processed ?
            MaterialStateProperty.all<Color>(Colors.green) :
            MaterialStateProperty.all<Color>(Colors.blueAccent),
          ),
          child: processed ? Icon(Icons.check) : Icon(Icons.clear),
          onPressed: onPressed,
        )
      ],
    ),
  );
}