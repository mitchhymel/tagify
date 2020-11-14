

import 'package:flutter/material.dart';
import 'package:tagify/src/screens/history_screen.dart';
import 'package:tagify/src/screens/library_screen.dart';
import 'package:tagify/src/screens/search_screen.dart';
import 'package:tagify/src/screens/settings_screen.dart';
import 'package:tagify/src/screens/spotify_playlist_screen.dart';
import 'package:tagify/src/screens/tag_side_bar.dart';
import 'package:tagify/src/screens/tags_screen.dart';

class MainContainer extends StatefulWidget {
  
  @override
  State createState() => MainContainerState();
}

class MainContainerState extends State<MainContainer> {

  int selectedIndex = 1;

  List<NavigationRailItem> railItems = [
    NavigationRailItem(
      icon: Icons.settings_applications_outlined,
      selectedIcon: Icons.settings_applications,
      label: 'Settings',
      builder: (ctx) => SettingsScreen(),
    ),
    NavigationRailItem(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: 'Search',
      builder: (ctx) => SearchScreen(),
    ),
    NavigationRailItem(
      icon: Icons.library_music_outlined,
      selectedIcon: Icons.library_music,
      label: 'Library',
      builder: (ctx) => LibraryScreen(),
    ),
    NavigationRailItem(
      icon: Icons.tag,
      selectedIcon: Icons.tag,
      label: 'Tags',
      builder: (ctx) => TagsScreen(),
    ),
    NavigationRailItem(
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: 'History',
      builder: (ctx) => HistoryScreen(),
    ),
    NavigationRailItem(
      icon: Icons.headset_outlined,
      selectedIcon: Icons.headset_sharp,
      label: 'Spotify',
      builder: (ctx) => SpotifyPlaylistScreen()
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState((){
              selectedIndex = index;
            });
          },
          labelType: NavigationRailLabelType.selected,
          destinations: railItems.map((e) => e.toDestination()).toList(),
        ),
        VerticalDivider(thickness: 1, width: 1),
        Flexible(
          flex: 4,
          child: railItems[selectedIndex].builder(context)
        ),
        VerticalDivider(thickness: 2, width: 2),
        Flexible(
          flex: 1,
          child: TagSideBar(),
        )
      ]
    )
  );
}

class NavigationRailItem {
  final IconData icon;
  final String label;
  final IconData selectedIcon;
  final WidgetBuilder builder;
  NavigationRailItem({
    @required this.icon,
    @required this.selectedIcon,
    @required this.label,
    @required this.builder,
  });

  NavigationRailDestination toDestination() => NavigationRailDestination(
    icon: Icon(icon),
    selectedIcon: Icon(selectedIcon),
    label: Text(label),
  );

}
