
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/spotify/spotify_account_widget.dart';

class SpotifyAccountRequired extends StatelessWidget {

  final Widget child;
  SpotifyAccountRequired({@required this.child});

  @override
  Widget build(BuildContext context) => SpotifyState((store) =>
  store.loggedIn ? child : Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: SpotifyAccountWidget()
      )
    )
  );
}