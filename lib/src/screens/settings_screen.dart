part of tagify;

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, child) => Column(
      children: [
        Container(height: 10),
        Material(
          color: Colors.green,
          elevation: 8.0,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            padding: EdgeInsets.all(20),
            child: SpotifyAccountWidget()
          ),
        ),
        Container(height: 10),
        Material(
          color: Colors.redAccent,
          elevation: 8.0,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            padding: EdgeInsets.all(20),
            child: LastFmAccountWidget()
          ),
        ),
      ],
    )
  );
}
