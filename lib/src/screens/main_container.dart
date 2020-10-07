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
      icon: Icons.headset_outlined,
      selectedIcon: Icons.headset_sharp,
      label: 'Spotify',
      builder: (ctx) => SpotifyPlaylistScreen()
    ),
    NavigationRailItem(
      icon: Icons.music_note_outlined,
      selectedIcon: Icons.music_note,
      label: 'LastFm',
      builder: (ctx) => LastFmScreen(),
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
