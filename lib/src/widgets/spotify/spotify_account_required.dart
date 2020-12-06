
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/spotify/spotify_account_widget.dart';

class SpotifyAccountRequired extends StatelessWidget {

  final Widget child;
  SpotifyAccountRequired({@required this.child});

  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, __) => store.loggedIn ? child : Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: SpotifyAccountWidget()
      )
    )
  );
}