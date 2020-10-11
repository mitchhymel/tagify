part of tagify;

class SpotifyPlaylistList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (context, store, child) => Scrollbar(
      child: GridView.builder(
        itemCount: store.playlists.length,
        itemBuilder: (ctx, index) => SpotifyPlaylistListItem(
          playlist: store.playlists[index],
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        )
      )
    ),
  );
}