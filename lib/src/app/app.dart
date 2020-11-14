

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/app_store.dart';
import 'package:tagify/src/state/history_store.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/spotify_store.dart';

import 'app_widget.dart';

class App extends StatelessWidget {
  final Color accentColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<AppStore>(create: (_) => AppStore()),
      ChangeNotifierProvider<SpotifyStore>(create: (_) => SpotifyStore()),
      ChangeNotifierProvider<LastFmStore>(create: (_) => lastFm),
      ChangeNotifierProvider<HistoryStore>(create: (_) => history),
    ],
    child: MaterialApp(
      title: 'Tagify',
      home: AppWidget(),
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
        toggleableActiveColor: accentColor
      ),
    )
  );
}