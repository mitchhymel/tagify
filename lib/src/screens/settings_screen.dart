import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/settings/firebase_account_widget.dart';
import 'package:tagify/src/widgets/settings/info_widget.dart';
import 'package:tagify/src/widgets/settings/lastfm_account_widget.dart';
import 'package:tagify/src/widgets/settings/spotify_account_widget.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, child) => Column(
      children: [
        SpotifyAccountWidget(),
        Container(height: 10),
        LastFmAccountWidget(),
        Container(height: 10),
        FirebaseAccountWidget(),
        Container(height: 10),
        InfoWidget(showText: true),
      ],
    )
  );
}
