
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/utils/utils.dart';

class PlaylistCreateButton extends HookWidget {

  @override
  Widget build(BuildContext context) {

    final firebase = useProvider(firebaseProvider);
    final playlistCreate = useProvider(playlistProvider);
    final spotify = useProvider(spotifyProvider);
    List<String> tracks = playlistCreate.getTracks(
        firebase.tagToTracks, firebase.trackToTags, firebase.trackCache);
    List<String> uris = tracks
        .where((x) => firebase.trackCache.containsKey(x))
        .map((x) => firebase.trackCache[x].externalUrl).toList();

    return ElevatedButton(
      child: Text('Start creating playlist of ${tracks.length} tracks'),
      onPressed: tracks.length > 0 && playlistCreate.playlistName.isNotEmpty ?
      () async {
        bool success = await playlistCreate.createPlaylist(
            spotify.user.id, uris, spotify.authedSpotify);
        if (success) {
          Utils.showSnackBar(context, 'Successfully created playlist');
        }
      } : null,
    );
  }
}