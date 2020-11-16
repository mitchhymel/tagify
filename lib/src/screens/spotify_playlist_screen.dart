import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/settings/spotify_account_widget.dart';
import 'package:tagify/src/widgets/spotify_playlist/spotify_playlist_list.dart';

class SpotifyPlaylistScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, __) => store.loggedIn ? SpotifyPlaylistList() :
      SpotifyAccountWidget()
  );
}