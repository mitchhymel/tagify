

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tagify/src/screens/history_screen.dart';
import 'package:tagify/src/screens/log_screen.dart';
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

  int selectedIndex = 2;

  List<NavigationRailItem> railItems = [
    NavigationRailItem(
      icon: Icons.settings_applications_outlined,
      selectedIcon: Icons.settings_applications,
      label: 'Settings',
      builder: (ctx) => SettingsScreen(),
    ),
    NavigationRailItem(
      icon: Icons.text_snippet_outlined,
      selectedIcon: Icons.text_snippet,
      label: 'Logs',
      builder: (ctx) => LogScreen(),
    ),
    NavigationRailItem(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: 'Search',
      builder: (ctx) => SearchScreen(),
    ),
    // NavigationRailItem(
    //   icon: Icons.library_music_outlined,
    //   selectedIcon: Icons.library_music,
    //   label: 'Library',
    //   builder: (ctx) => LibraryScreen(),
    // ),
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
    if (!Platform.isWindows) NavigationRailItem(
      icon: Icons.queue_outlined,
      selectedIcon: Icons.queue,
      label: 'Queue',
      builder: (ctx) => TagSideBar(),
    )
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Row(
        children: [
          if (Platform.isWindows) NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState((){
                selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: railItems.map((e) => e.toDestination()).toList(),
          ),
          if (Platform.isWindows) VerticalDivider(thickness: 1, width: 1),
          Flexible(
              flex: 2,
              child: railItems[selectedIndex].builder(context)
          ),
          if (Platform.isWindows) VerticalDivider(thickness: 2, width: 2),
          if (Platform.isWindows) Flexible(
            flex: 1,
            child: TagSideBar(),
          )
        ]
      )
    ),
    bottomNavigationBar: Platform.isWindows ? null : BottomNavigationBar(
      items: railItems.map((e) => e.toItem()).toList(),
      currentIndex: selectedIndex,
      selectedItemColor: Colors.redAccent,
      onTap: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
    ),
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

  BottomNavigationBarItem toItem() => BottomNavigationBarItem(
    icon: Icon(icon),
    activeIcon: Icon(selectedIcon),
    label: label,
  );

}
