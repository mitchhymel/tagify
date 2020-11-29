
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/custom_text_field.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';

class PlaylistCreateControls extends StatelessWidget {

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<LastFmStore>(
          builder: (_, store, __) => IntrinsicWidth(
            child: CheckboxListTile(
              title: Text('Must have ALL tags'),
              value: store.mustHaveAllWithTags,
              onChanged: (v) => store.mustHaveAllWithTags = v,
            ),
          )
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('With tags:'),
            Container(width: 10),
            Consumer<LastFmStore>(
              builder: (_, store, __) => TagChipList(
                tags: store.withTags,
                onAddTag: store.addWithTag,
                onRemoveTag: store.removeWithTag,
              )
            )
          ],
        ),
        Container(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Without tags:'),
            Container(width: 10),
            Consumer<LastFmStore>(
              builder: (_, store, __) => TagChipList(
                tags: store.withoutTags,
                onAddTag: store.addWithoutTag,
                onRemoveTag: store.removeWithoutTag,
              )
            )
          ],
        ),
        Container(height: 10),
        Row(
          children: [
            Text('Playlist name: '),
            Container(width: 10),
            Consumer<LastFmStore>(
              builder: (_, store, __) => Expanded(
                child: CustomTextField(
                  hint: 'Enter playlist name',
                  onChanged: (x) => store.playlistName = x,
                  onClear: () => store.playlistName = '',
                  initialText: store.playlistName,
                )
              )
            )
          ],
        ),
        Container(height: 10),
        Consumer2<LastFmStore, SpotifyStore>(
          builder: (_, lastfm, spotify, __) => ElevatedButton(
            child: Text('Start creating playlist of ${lastfm.playlistTracks.length} tracks'),
            onPressed: lastfm.playlistTracks.length > 0 && lastfm.playlistName.isNotEmpty ? () async {
              bool success = await lastfm.createPlaylist(
                  spotify.user.id, spotify.spotify);
              if (success) {
                Utils.showSnackBar(context, 'Successfully created playlist');
              }
            } : null,
          )
        )
      ],
    )
  );
}