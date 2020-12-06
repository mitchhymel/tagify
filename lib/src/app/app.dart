import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/app/login_screen.dart';
import 'package:tagify/src/app/main_container.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/history_store.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/queue_store.dart';
import 'package:tagify/src/state/search_store.dart';
import 'package:tagify/src/state/spotify_store.dart';

class App extends StatelessWidget {
  final Color accentColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<LogStore>(create: (_) => logStore),
      ChangeNotifierProvider<SpotifyStore>(create: (_) => SpotifyStore()),
      ChangeNotifierProvider<LastFmStore>(create: (_) => LastFmStore()),
      ChangeNotifierProvider<FirebaseStore>(create: (_) => FirebaseStore()),
      ChangeNotifierProvider<SearchStore>(create: (_) => SearchStore()),
      ChangeNotifierProvider<HistoryStore>(create: (_) => HistoryStore()),
      ChangeNotifierProvider<QueueStore>(create: (_) => QueueStore()),
    ],
    child: MaterialApp(
      title: 'Tagify',
      home: Consumer<FirebaseStore>(
        builder: (_, store, __) => store.loggedIn
          ? MainContainer() : LoginScreen()
      ),
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