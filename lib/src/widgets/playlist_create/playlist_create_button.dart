
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
    List<String> uris = playlistCreate.getUris(
        firebase.tagToTracks, firebase.trackToTags, firebase.trackCache);

    return ElevatedButton(
      child: Text('Start creating playlist of ${uris.length} tracks'),
      onPressed: uris.length == 0 || playlistCreate.playlistName.isEmpty ? null :
      () async {
        var playlists = spotify.playlists.where((p) =>
          p.name == playlistCreate.playlistName);
        if (playlists != null && playlists.isNotEmpty) {
          var existingPlaylist = playlists.first;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('A playlist named "${existingPlaylist.name}" already exists'),
                  Container(height: 10),
                  ElevatedButton(
                    child: Text('Add to existing playlist'),
                    onPressed: () async {
                      Navigator.pop(context, false);

                      bool success = await playlistCreate.addTracksToPlaylist(
                          existingPlaylist.id, uris, spotify.authedSpotify);
                      if (success) {
                        Utils.showSnackBar(context, 'Successfully added tracks to playlist');
                      }
                    }
                  ),
                  ElevatedButton(
                    child: Text('Create new playlist with the same name'),
                    onPressed: () async {
                      Navigator.pop(context, false);

                      bool success = await playlistCreate.createPlaylist(
                          spotify.user.id, uris, spotify.authedSpotify);
                      if (success) {
                        Utils.showSnackBar(context, 'Successfully created playlist');
                      }
                    }
                  ),
                  ElevatedButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
            )
          );
        }
        else {
          bool success = await playlistCreate.createPlaylist(
              spotify.user.id, uris, spotify.authedSpotify);
          if (success) {
            Utils.showSnackBar(context, 'Successfully created playlist');
          }
        }
      },
    );
  }
}