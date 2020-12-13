import 'dart:async';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/log_store.dart';
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
  Widget build(BuildContext context) => Consumer2<SpotifyStore, FirebaseStore>(
    builder: (_, store, firebase, child) {
      if (!store.loggedIn) {
        var button = ElevatedButton.icon(
          icon: Icon(FontAwesome.spotify),
          label: Text('Login to Spotify'),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.all(20)),
            backgroundColor: MaterialStateProperty.all(Colors.green),
          ),
          onPressed: () async {
            String authUri = store.realAuthUri;
            if (kIsWeb) {
              StreamSubscription<html.MessageEvent> sub;
              sub = html.window.onMessage.listen((event) async {
                if (Utils.redirectUriForSpotify(event)) {
                  // the event.data is the callback url we need
                  // pass it to the store
                  var uri = Uri.parse(event.data.toString());
                  String code = uri.queryParameters['code'];
                  var creds = await firebase.connectSpotify(code, Utils.REDIRECT_URI);
                  if (creds == null) {
                    log('Could not connect to Spotify');
                    sub.cancel();
                    return;
                  }

                  await store.loginFromCreds(creds);

                  sub.cancel();
                }
                else {
                  print(event.origin);
                }
              });

              if (await canLaunch(authUri)) {
                await launch(authUri);
              }
              else {
                print('Could not launch url');
              }
            }
            else {
              if (await canLaunch(authUri)) {
                await launch(authUri);
              }
              else {
                print('Could not launch url');
              }
            }
          }
        );

        if (kIsWeb) {
          return button;
        }

        return CustomCard(child: Row(
          children: [
            button,
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
