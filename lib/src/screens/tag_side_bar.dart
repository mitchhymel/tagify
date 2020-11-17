
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/common/tabbed_container.dart';
import 'package:tagify/src/widgets/tag_side_bar/queue_albums_container.dart';
import 'package:tagify/src/widgets/tag_side_bar/queue_artists_container.dart';
import 'package:tagify/src/widgets/tag_side_bar/queue_tracks_container.dart';

class TagSideBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Flexible(
        flex: 3,
        child: TabbedContainer([
          TabItem(
            icon: Icons.audiotrack,
            text: 'Tracks',
            child: QueueTracksContainer(),
          ),
          TabItem(
            icon: Icons.person,
            text: 'Artists',
            child: QueueArtistsContainer(),
          ),
          TabItem(
            icon: Icons.album,
            text: 'Albums',
            child: QueueAlbumsContainer(),
          ),
        ]),
      )
    ],
  );
}