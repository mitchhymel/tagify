part of tagify;

class SpotifyAccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, child) {

      if (!store.loggedIn) {
        return Column(
          children: [
            RaisedButton(
              child: Text('Launch browser to login to Spotify'),
              onPressed: () async {
                if (await canLaunch(store.authUri.toString())) {
                  await launch(store.authUri.toString());
                }
                else {
                  print('Could not launch url');
                }
              }
            ),
            TextField(
              showCursor: true,
              autofocus: false,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Paste the resulting redirect uri here',
              ),
              onSubmitted: (str) {
                store.loginFromRedirectUri(Uri.parse(str));
              },
            ),
          ],
        );
      }

      return Column (
        children: [
          Container(
            height: 190,
            width: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(store.user.images[0].url)
              )
            ),
          ),
          RaisedButton(
            child: Text('Logout from Spotify'),
            onPressed: () => store.logout()
          ),
        ],
      );
    }
  );
}
