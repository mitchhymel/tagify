part of tagify;

class MainContainer extends StatefulWidget {
  
  @override
  State createState() => MainContainerState();
}

class MainContainerState extends State<MainContainer> {

  int selectedIndex = 0;

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
      icon: Icons.music_note_outlined,
      selectedIcon: Icons.music_note,
      label: 'LastFm',
      builder: (ctx) => LastFmScreen(),
    ),
    NavigationRailItem(
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: 'History',
      builder: (ctx) => HistoryScreen(),
    ),
    // NavigationRailItem(
    //   icon: Icons.headset_outlined,
    //   selectedIcon: Icons.headset_sharp,
    //   label: 'Spotify',
    //   builder: (ctx) => SpotifyPlaylistScreen()
    // ),
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
        Expanded(
          child: railItems[selectedIndex].builder(context)
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
