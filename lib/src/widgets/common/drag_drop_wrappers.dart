
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/models.dart';

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
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, c) => WrapDropTarget<TrackCacheKey>(
      child: child,
      onAcceptWithDetails: (details) => store.addTrackToQueue(details.data),
    )
  );
}

class WrapDropTargetArtist extends StatelessWidget {
  final Widget child;
  WrapDropTargetArtist({@required this.child});

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
      builder: (_, store, c) => WrapDropTarget<Artist>(
        child: child,
        onAcceptWithDetails: (details) => store.addArtistToQueue(details.data),
      )
  );
}

class WrapDropTargetAlbum extends StatelessWidget {
  final Widget child;
  WrapDropTargetAlbum({@required this.child});

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
      builder: (_, store, c) => WrapDropTarget<Album>(
        child: child,
        onAcceptWithDetails: (details) => store.addAlbumToQueue(details.data),
      )
  );
}