import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class SpotifyPlaylistListItem extends HookWidget {

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
  Widget build(BuildContext context) {

    final spotify = useProvider(spotifyProvider);
    final firebase = useProvider(firebaseProvider);

    if (Utils.isBigScreen(context)
        && spotify.playlistIdToTracks.containsKey(playlist.id)) {
      return Draggable(
          feedback: _getCard(
            selected: spotify.selectedPlaylist == playlist,
            onTap: () => spotify.setSelectedAndEnsureCached(playlist,
                firebase.addAllToCache
            )
          ),
          data: spotify.playlistIdToTracks[playlist.id],
          child: _getCard(
            selected: spotify.selectedPlaylist == playlist,
            onTap: () => spotify.setSelectedAndEnsureCached(playlist,
                firebase.addAllToCache
            )
          )
      );
    }

    return _getCard(
      selected: spotify.selectedPlaylist == playlist,
      onTap: () => spotify.setSelectedAndEnsureCached(playlist,
          firebase.addAllToCache
      )
    );
  }
}