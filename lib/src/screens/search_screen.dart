part of tagify;

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

    var store = Provider.of<LastFmStore>(context, listen: false);
    var response = await store.lastFm.track.search(track,
      artist: artist,
    );

    if (response.error != null) {
      print(response.error);
      return;
    }

    List<TrackSearchResult> tracks = [];
    List maps = response.data['results']['trackmatches']['track'];
    maps.forEach((element) {
      tracks.add(TrackSearchResult.fromJson(element));
     });

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