part of tagify;

class SpotifyPlaylistListItem extends StatelessWidget {

  final spot.PlaylistSimple playlist;
  SpotifyPlaylistListItem({@required this.playlist});

  BoxDecoration _getDecoration() {
    if (playlist.images != null && playlist.images.length > 0) {
      return BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(playlist.images[0].url)
        )
      );
    }

    return BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => print('ta'),
    child: Container(
      height: 190,
      width: 190,
      decoration: _getDecoration(),
      child: Center(
        child: Container(
          color: Colors.black54,
          child: Text(playlist.name),
        )
      )
    ),
  );
}