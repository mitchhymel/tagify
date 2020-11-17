import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

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

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, child) { 

      if (!store.loggedIn) {
        return CustomCard(child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    showCursor: true,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Session Key',
                    ),
                    controller: _sessionKeyController,
                  )
                ),
                Container(width: 10),
                ElevatedButton(
                  child: Text('Login'),
                  onPressed: () async {
                    if (_sessionKeyController.text.isEmpty) {
                      log('session key is empty');
                      return;
                    }
                    await store.loginFromSession(_sessionKeyController.text);
                  }
                )
              ]
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
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                ),
                Container(width: 10),
                ElevatedButton(
                  child: Text('Login'),
                  onPressed: () async {
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
                    await store.login(userName, password);
                  },
                )
              ],
            )
          ],
        ));
      }

      return CustomCard(child: Column(
        children: [
          Container(
            height: 190,
            width: 190,
            child: Text(store.userSession.name),
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              // image: DecorationImage(
              //   fit: BoxFit.fill,
              //   image: NetworkImage(store.images[0].url)
              // )
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
