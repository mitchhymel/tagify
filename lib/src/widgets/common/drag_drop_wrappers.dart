
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';

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
  Widget build(BuildContext context) => QueueState((store) =>
    WrapDropTarget<List<String>>(
      child: WrapDropTarget<String>(
        child: child,
        onAcceptWithDetails: (details) => store.addTrackToQueue(details.data),
      ),
      onAcceptWithDetails: (details) => store.addTracksToQueue(details.data),
    ),
  );
}