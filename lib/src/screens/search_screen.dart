import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/common/tabbed_container.dart';
import 'package:tagify/src/widgets/search/albums/search_albums_container.dart';
import 'package:tagify/src/widgets/search/artists/search_artists_container.dart';
import 'package:tagify/src/widgets/search/tracks/search_tracks_container.dart';

class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => TabbedContainer([
    TabItem(
      icon: Icons.audiotrack,
      text: 'Tracks',
      child: SearchTracksContainer(),
    ),
    TabItem(
      icon: Icons.person,
      text: 'Artists',
      child: SearchArtistsContainer(),
    ),
    TabItem(
      icon: Icons.album,
      text: 'Albums',
      child: SearchAlbumsContainer(),
    ),
  ]);
}