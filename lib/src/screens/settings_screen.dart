import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/firebase/firebase_account_widget.dart';
import 'package:tagify/src/widgets/settings/info_widget.dart';
import 'package:tagify/src/widgets/spotify/spotify_account_widget.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SpotifyState((store) => SingleChildScrollView(
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
