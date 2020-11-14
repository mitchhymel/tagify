import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/search_controls.dart';

class SearchScreen extends StatefulWidget {

  @override
  State createState() => new SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {

  List<TrackSearchResult> _tracks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onSearchAlbum(String album) {

  }

  _onSearchArtist(String artist) {

  }

  _onSearchTrack(String track, String artist) async {
    setState(() {
      _tracks = [];
    });

    var store = Provider.of<LastFmStore>(this.context, listen: false);
    var response = await store.lastFm.track.search(track,
      artist: artist,
    );

    if (response.error != null) {
      print(response.error);
      return;
    }

    List<TrackSearchResult> tracks = TrackSearchResult.fromLastFmResponse(response);

    setState(() {
      _tracks = tracks;
    });
  }


  @override
  Widget build(BuildContext context) => Column(
    children: [
      SearchControls(
        onSearchAlbum: _onSearchAlbum,
        onSearchArtist: _onSearchArtist,
        onSearchTrack: _onSearchTrack,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: _tracks.length,
          itemBuilder: (ctx, index) => Text(_tracks[index].name),
        )
      ),
    ],
  );
}