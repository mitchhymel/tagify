import 'dart:async';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotifyAccountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<SpotifyStore>(
    builder: (_, store, child) {

      if (!store.loggedIn) {
        return CustomCard(child: Row(
          children: [
            ElevatedButton(
              child: Text('Launch window to login to Spotify'),
              onPressed: () async {
                if (kIsWeb) {
                  StreamSubscription<html.MessageEvent> sub;
                  sub = html.window.onMessage.listen((event) {
                    if (Utils.redirectUriForSpotify(event)) {
                      // the event.data is the callback url we need
                      // pass it to the store
                      var uri = Uri.parse(event.data.toString());
                      store.loginFromRedirectUri(uri);
                      sub.cancel();
                    }
                    else {
                      print(event.origin);
                    }
                  });

                  if (await canLaunch(store.authUri.toString())) {
                    await launch(store.authUri.toString());
                  }
                  else {
                    print('Could not launch url');
                  }
                }
                else {
                  if (await canLaunch(store.authUri.toString())) {
                    await launch(store.authUri.toString());
                  }
                  else {
                    print('Could not launch url');
                  }
                }
              }
            ),
            if (!kIsWeb) Container(width: 10, height: 1),
            if (!kIsWeb) Expanded(
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
