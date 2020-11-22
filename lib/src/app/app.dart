import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/app/main_container.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/spotify_store.dart';

class App extends StatelessWidget {
  final Color accentColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<LogStore>(create: (_) => logStore),
      ChangeNotifierProvider<SpotifyStore>(create: (_) => SpotifyStore()),
      ChangeNotifierProvider<LastFmStore>(create: (_) => LastFmStore()),
    ],
    child: MaterialApp(
      title: 'Tagify',
      home: MainContainer(),
      theme: ThemeData.dark().copyWith(
        accentColor: accentColor,
        indicatorColor: accentColor,
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Colors.white,
          labelColor: accentColor,
        ),
        navigationRailTheme: NavigationRailThemeData(
            selectedIconTheme: IconThemeData(
              color: accentColor,
            ),
            selectedLabelTextStyle: TextStyle(
              color: accentColor
            )
        ),
        toggleableActiveColor: accentColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        )
      ),
    )
  );
}