


import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tagify/src/screens/history_screen.dart';
import 'package:tagify/src/screens/log_screen.dart';
import 'package:tagify/src/screens/search_screen.dart';
import 'package:tagify/src/screens/settings_screen.dart';
import 'package:tagify/src/screens/spotify_playlist_create_screen.dart';
import 'package:tagify/src/screens/spotify_playlists_screen.dart';
import 'package:tagify/src/screens/queue_screen.dart';
import 'package:tagify/src/screens/tags_screen.dart';
import 'package:tagify/src/utils/utils.dart';

class MainContainer extends StatefulWidget {
  
  @override
  State createState() => MainContainerState();
}

class MainContainerState extends State<MainContainer> {

  int selectedIndex = 2;

  List<NavigationRailItem> railItems = [];
  bool get showSidebar => (selectedIndex >= 2 && selectedIndex <=5);
  double lastWindowWidth = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, (){
      _checkAndUpdateRailItemsBasedOnWidth(context);
    });
  }

  void _checkAndUpdateRailItemsBasedOnWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width != lastWindowWidth) {
      setState(() {
        lastWindowWidth = width;
        if (selectedIndex == 7 && Utils.isBigScreen(context)) {
          selectedIndex = 2;
        }
        railItems = [
          NavigationRailItem(
            icon: Icons.text_snippet_outlined,
            selectedIcon: Icons.text_snippet,
            label: 'Logs',
            builder: (ctx) => LogScreen(),
          ),
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
          // NavigationRailItem(
          //   icon: Icons.library_music_outlined,
          //   selectedIcon: Icons.library_music,
          //   label: 'Library',
          //   builder: (ctx) => LibraryScreen(),
          // ),
          NavigationRailItem(
            icon: Icons.history_outlined,
            selectedIcon: Icons.history,
            label: 'History',
            builder: (ctx) => HistoryScreen(),
          ),
          NavigationRailItem(
            icon: Icons.tag,
            selectedIcon: Icons.tag,
            label: 'Tags',
            builder: (ctx) => TagsScreen(),
          ),
          NavigationRailItem(
            icon: SimpleLineIcons.social_spotify,
            selectedIcon: FontAwesome.spotify,
            label: 'Playlists',
            builder: (ctx) => SpotifyPlaylistsScreen()
          ),
          NavigationRailItem(
            icon: Icons.playlist_add_outlined,
            selectedIcon: Icons.playlist_add,
            label: 'Add',
            builder: (ctx) => SpotifyPlaylistCreateScreen(),
          ),
          if (!Utils.isBigScreen(context)) NavigationRailItem(
            icon: Icons.queue_outlined,
            selectedIcon: Icons.queue,
            label: 'Queue',
            builder: (ctx) => QueueScreen(),
          ),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkAndUpdateRailItemsBasedOnWidth(context);
    return Scaffold(
      body: SafeArea(
          child: Row(
              children: [
                if (Utils.isBigScreen(context)) NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (int index) {
                    setState((){
                      selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: railItems.map((e) => e.toDestination()).toList(),
                ),
                if (Utils.isBigScreen(context)) VerticalDivider(thickness: 1, width: 1),
                Flexible(
                    flex: 2,
                    child: railItems[selectedIndex].builder(context)
                ),
                if (Utils.isBigScreen(context) && showSidebar) VerticalDivider(thickness: 2, width: 2),
                if (Utils.isBigScreen(context) && showSidebar) Flexible(
                  flex: 1,
                  child: QueueScreen(),
                )
              ]
          )
      ),
      bottomNavigationBar: Utils.isBigScreen(context)  ? null : BottomNavigationBar(
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
