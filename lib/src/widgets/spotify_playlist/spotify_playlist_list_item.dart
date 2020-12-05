import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class SpotifyPlaylistListItem extends StatelessWidget {

  final spot.PlaylistSimple playlist;
  SpotifyPlaylistListItem({@required this.playlist});

  BoxDecoration _getDecoration() {
    if (playlist.images != null && playlist.images.length > 0) {
      return BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(playlist.images[0].url)
        )
      );
    }

    return BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey,
    );
  }

  Widget _getCard({
    @required bool selected,
    @required VoidCallback onTap
  }) => CustomCard(
    color: selected ? Colors.redAccent : Colors.black12,
    onTap: onTap,
    // todo: onlongpress for mobile
    child: Container(
      height: 150,
      width: 150,
      decoration: _getDecoration(),
      child: Center(
        child: Container(
          color: Colors.black54,
          child: Text(playlist.name),
        )
      )
    ),
  );

  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, __) => Utils.isBigScreen(context)
        && store.playlistIdToTracks.containsKey(playlist.id) ?
        Draggable(
          feedback: _getCard(
            selected: store.selectedPlaylist == playlist,
            onTap: () => store.setSelectedAndEnsureCached(playlist,
              Provider.of<FirebaseStore>(context, listen: false).addAllToCache
            )
          ),
          data: store.playlistIdToTracks[playlist.id],
          child: _getCard(
            selected: store.selectedPlaylist == playlist,
            onTap: () => store.setSelectedAndEnsureCached(playlist,
              Provider.of<FirebaseStore>(context, listen: false).addAllToCache
            )
          )
        ) :
        _getCard(
          selected: store.selectedPlaylist == playlist,
          onTap: () => store.setSelectedAndEnsureCached(playlist,
            Provider.of<FirebaseStore>(context, listen: false).addAllToCache
          )
        )
  );
}