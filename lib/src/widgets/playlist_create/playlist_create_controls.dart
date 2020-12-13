
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/custom_text_field.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';
import 'package:tagify/src/widgets/playlist_create/playlist_create_button.dart';

class PlaylistCreateControls extends StatelessWidget {

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaylistCreateState((store) => IntrinsicWidth(
          child: CheckboxListTile(
            title: Text('Must have ALL tags'),
            value: store.mustHaveAllIncludeTags,
            onChanged: (v) => store.mustHaveAllIncludeTags = v,
          ),
        )),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Include tracks with tags:'),
            Container(width: 10),
            PlaylistCreateState((store) => TagChipList(
              tags: store.includeTags,
              onAddTag: store.addIncludeTag,
              onRemoveTag: store.removeIncludeTag,
            ))
          ],
        ),
        Container(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Exclude tracks with tags:'),
            Container(width: 10),
            PlaylistCreateState((store) => TagChipList(
              tags: store.excludeTags,
              onAddTag: store.addExcludeTag,
              onRemoveTag: store.removeExcludeTag,
            ))
          ],
        ),
        Container(height: 10),
        Row(
          children: [
            Text('Playlist name: '),
            Container(width: 10),
            PlaylistCreateState((store) => Expanded(
              child: CustomTextField(
                hint: 'Enter playlist name',
                onChanged: (x) => store.playlistName = x,
                onClear: () => store.playlistName = '',
                initialText: store.playlistName,
              )
            ))
          ],
        ),
        Container(height: 10),
        PlaylistCreateButton(),
      ],
    )
  );
}