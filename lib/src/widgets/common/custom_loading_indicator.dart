
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';

class CustomLoadingIndicator extends StatelessWidget {

  final bool showProgress;
  CustomLoadingIndicator(this.showProgress);

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.all(4),
    child: showProgress ? Center(child: LinearProgressIndicator())
      : Container(height: 4),
  );
}

class PlaylistFetchLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SpotifyState(
      (store) => CustomLoadingIndicator(store.fetchingPlaylist)
  );
}