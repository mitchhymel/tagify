import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/search/albums/search_albums_container.dart';
import 'package:tagify/src/widgets/search/artists/search_artists_container.dart';
import 'package:tagify/src/widgets/search/tracks/search_tracks_container.dart';

class SearchScreen extends StatefulWidget {

  @override
  State createState() => new SearchScreenState();
}

class TabItem {
  final IconData icon;
  final String text;
  final Widget child;
  TabItem({
    @required this.icon,
    @required this.text,
    @required this.child,
  });
}

class SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin{

  TabController controller;

  List<TabItem> tabs = [
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
  ];

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) => Column(
    children: [
      TabBar(
        controller: controller,
        tabs: tabs.map((e) => Tab(
            icon: Icon(e.icon),
            text: e.text
        )).toList(),
      ),
      Expanded(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: tabs.map((e) => e.child).toList()
        )
      )
    ],
  );
}