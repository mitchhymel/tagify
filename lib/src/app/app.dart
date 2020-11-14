

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/app_store.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/spotify_store.dart';

import 'app_widget.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<AppStore>(create: (_) => AppStore()),
      ChangeNotifierProvider<SpotifyStore>(create: (_) => SpotifyStore()),
      ChangeNotifierProvider<LastFmStore>(create: (_) => LastFmStore()),
    ],
    child: MaterialApp(
      title: 'Tagify',
      home: AppWidget(),
      theme: ThemeData.dark(),
    )
  );
}