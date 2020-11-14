import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'file:///E:/Dev/Flutter/MyProjects/tagify/lib/src/widgets/settings/lastfm_account_widget.dart';
import 'file:///E:/Dev/Flutter/MyProjects/tagify/lib/src/widgets/settings/spotify_account_widget.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, child) => Column(
      children: [
        SpotifyAccountWidget(),
        Container(height: 10),
        LastFmAccountWidget(),
      ],
    )
  );
}
