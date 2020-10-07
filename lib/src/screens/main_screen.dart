part of tagify;

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Tagify'),
      ),
      body: Consumer<AuthStore>(
          builder: (_, store, child) => Column(
                children: [
                  if (store.isLoggedIn)
                    Text('ay'),
                  if (store.isLoggedIn)
                    RaisedButton(
                      child: Text('ay'),
                      onPressed: () async {
                        var res = await store.spotify.me.recentlyPlayed();
                        res.forEach((element) => print(element.name));
                      }
                    ),
                  if (!store.isLoggedIn)
                    SelectableText(
                      store.authUri.toString(),
                    ),
                  if (!store.isLoggedIn)
                    TextField(
                      showCursor: true,
                      autofocus: false,
                      onSubmitted: (str) {
                        store.loginFromRedirectUri(Uri.parse(str));
                      },
                    ),
                ],
              )));
}
