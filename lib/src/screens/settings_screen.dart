import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/firebase/firebase_account_widget.dart';
import 'package:tagify/src/widgets/settings/info_widget.dart';
import 'package:tagify/src/widgets/spotify/spotify_account_widget.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, child) => SingleChildScrollView(
      child: IntrinsicHeight(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(height: 10),
            SpotifyAccountWidget(),
            Container(height: 10),
            FirebaseAccountWidget(),
            Container(height: 10),
            InfoWidget(showText: true),
          ],
        )
      )
    )
  );
}
