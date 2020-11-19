import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/common/tabbed_container.dart';
import 'package:tagify/src/widgets/tags/albums/tags_albums_container.dart';
import 'package:tagify/src/widgets/tags/artists/tags_artists_container.dart';
import 'package:tagify/src/widgets/tags/tags_controls.dart';
import 'package:tagify/src/widgets/tags/tags_list.dart';
import 'package:tagify/src/widgets/tags/tracks/tags_tracks_container.dart';

class TagsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TagsControls(),
      Consumer<LastFmStore>(
        builder: (_, store, __) => CustomLoadingIndicator(store.tagsFetching),
      ),
      Expanded(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Icon(Icons.tag),
                  Expanded(
                    child: TagsList()
                  )
                ],
              )
            ),
            Flexible(
              flex: 3,
              child: TabbedContainer([
                TabItem(
                  icon: Icons.audiotrack,
                  text: 'Tracks',
                  child: TagsTracksContainer(),
                ),
                TabItem(
                  icon: Icons.person,
                  text: 'Artists',
                  child: TagsArtistsContainer(),
                ),
                TabItem(
                  icon: Icons.album,
                  text: 'Albums',
                  child: TagsAlbumsContainer(),
                ),
              ]),
            )
          ],
        )
      ),
    ],
  );
}