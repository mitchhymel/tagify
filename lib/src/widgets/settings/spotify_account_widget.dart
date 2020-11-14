import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyAccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, child) {

      if (!store.loggedIn) {
        return CustomCard(child: Row(
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
            Container(width: 10),
            Expanded(
              child: TextField(
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
            )
          ],
        ));
      }

      return CustomCard(child: Column (
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
      ));
    }
  );
}
