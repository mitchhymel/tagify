
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/queue_store.dart';

typedef DropTargetCallback<T> = void Function(DragTargetDetails<T>);
class WrapDropTarget<T> extends StatelessWidget {
  final Widget child;
  final DropTargetCallback<T> onAcceptWithDetails;
  WrapDropTarget({
    @required this.child,
    @required this.onAcceptWithDetails,
  });

  @override
  Widget build(BuildContext context) => DragTarget<T>(
      onAcceptWithDetails: onAcceptWithDetails,
      builder: (_, candidateData, rejectedData) => Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            width: 10,
            color: candidateData.length > 0 ? Colors.redAccent : Colors.transparent
          ),
        ),
        child: child,
      )
  );
}

class WrapDropTargetTrack extends StatelessWidget {
  final Widget child;
  WrapDropTargetTrack({@required this.child});

  @override
  Widget build(BuildContext context) => Consumer<QueueStore>(
    builder: (_, store, c) => WrapDropTarget<List<String>>(
      child: WrapDropTarget<String>(
        child: child,
        onAcceptWithDetails: (details) => store.addTrackToQueue(details.data),
      ),
      onAcceptWithDetails: (details) => store.addTracksToQueue(details.data),
    ),
  );
}