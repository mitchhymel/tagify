import 'dart:async';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';

class LastFmAccountWidget extends StatefulWidget {

  @override
  State createState() => LastFmAccountWidgetState();
}

class LastFmAccountWidgetState extends State<LastFmAccountWidget> {

  TextEditingController _userController;
  TextEditingController _passController;
  TextEditingController _sessionKeyController;

  @override
  void initState() {
    super.initState();

    _userController = new TextEditingController();
    _passController = new TextEditingController();
    _sessionKeyController = new TextEditingController();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    _sessionKeyController.dispose();
    super.dispose();
  }

  Widget _getOAuthLoginButton(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => ElevatedButton(
        child: Text('Launch window to login to Lastfm'),
        onPressed: () async {
          if (kIsWeb) {
            StreamSubscription<html.MessageEvent> sub;
            sub = html.window.onMessage.listen((event) async {
              if (Utils.redirectUriForLastFm(event)) {
                // the event.data is the callback url we need, parse out token
                String token = Utils.getTokenFromLastFmRedirectUri(event.data.toString());
                if (await store.loginFromToken(token)) {
                  sub.cancel();
                }
              }
              else {
                log('Error when trying to login from redirect');
              }
            });

            String url = store.api.getAuthUriWithCallbackUri(Utils.REDIRECT_URI);
            if (await canLaunch(url)) {
              await launch(url);
            }
            else {
              print('Could not launch url');
            }
          }
        }
    )
  );

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, child) { 

      if (!store.loggedIn) {
        final onSubmit = () async {
          String userName = _userController.text;
          String password = _passController.text;

          if (userName.isEmpty) {
            log('username is null');
            return;
          }

          if (password.isEmpty) {
            log('password is null');
            return;
          }

          var res = await store.login(userName, password);

          if (!res) {
            Utils.showSnackBar(context,
              'Login failed, try reentering username and password',
              isError: true
            );
          }
        };

        return CustomCard(child: Column(
          children: [
            if (kIsWeb) _getOAuthLoginButton(context),
            if (!kIsWeb) ...[
              Text('Login with your lastfm account',
                  style: TextStyle(
                    fontSize: 20,
                  )
              ),
              Container(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      showCursor: true,
                      autofocus: false,
                      textAlign: TextAlign.center,
                      controller: _userController,
                      decoration: InputDecoration(
                        hintText: 'Username',
                      ),
                    ),
                  ),
                  Container(width: 10),
                  Expanded(
                    child: TextField(
                      showCursor: true,
                      autofocus: false,
                      textAlign: TextAlign.center,
                      controller: _passController,
                      obscureText: true,
                      onSubmitted: (x) => onSubmit(),
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ],
              ),
              Container(height: 10),
              ElevatedButton(
                child: Text('Login'),
                onPressed: onSubmit,
              )
            ]
          ],
        ));
      }

      return CustomCard(child: Column(
        children: [
          Text(store.userSession.name),
          if (store.user != null && store.user.images != null) Container(
            height: 190,
            width: 190,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(store.user.images[3].text)
              )
            ),
          ),
          RaisedButton(
            child: Text('Logout from Lastfm'),
            onPressed: () => store.logout()
          ),
        ]
      ));
    }
  );
}
