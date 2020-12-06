
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/playlist_create_store.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/utils/utils.dart';

class PlaylistCreateButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var cache = Provider.of<FirebaseStore>(context);
    List<String> tracks = Provider.of<PlaylistCreateStore>(context).getTracks(
      cache.tagToTracks, cache.trackToTags);
    List<String> uris = tracks.map((x) => cache.trackCache[x].externalUrl).toList();

    return Consumer2<PlaylistCreateStore, SpotifyStore>(
        builder: (_, store, spot, __) => ElevatedButton(
          child: Text('Start creating playlist of ${tracks.length} tracks'),
          onPressed: tracks.length > 0
              && store.playlistName.isNotEmpty ? () async {

            bool success = await store.createPlaylist(
                spot.user.id, uris);
            if (success) {
              Utils.showSnackBar(context, 'Successfully created playlist');
            }

            // var playlist = spot.playlists.where((p)
            // => p.name == store.playlistName);
            // if (playlist != null && playlist.isNotEmpty) {
            //   showDialog(
            //       context: context,
            //       builder: (_) => AlertDialog(
            //           content: Text('A playlist named "${playlist.first.name}" with tracks already exists'),
            //           actions: [
            //             FlatButton(
            //               child: Text('Cancel'),
            //               onPressed: () => Navigator.pop(context, false),
            //             ),
            //             Container(width: 10),
            //             FlatButton(
            //                 child: Text('Create new playlist with the same name'),
            //                 onPressed: () async {
            //                   Navigator.pop(context, false);
            //
            //                   bool success = await store.createPlaylist(
            //                       spot.user.id, uris);
            //                   if (success) {
            //                     Utils.showSnackBar(context, 'Successfully created playlist');
            //                   }
            //                 }
            //             ),
            //             FlatButton(
            //                 child: Text('Update existing playlist'),
            //                 onPressed: () async {
            //
            //                 }
            //             )
            //           ]
            //       )
            //   );
            // }
            // else {
            //   bool success = await store.createPlaylist(
            //       spot.user.id, uris);
            //   if (success) {
            //     Utils.showSnackBar(context, 'Successfully created playlist');
            //   }
            // }
          } : null,
        )
    );
  }
}