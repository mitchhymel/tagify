
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';

class LoginWithGoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<FirebaseStore>(
    builder: (_, store, __) => store.loggedIn ? Container() : SignInButton(
      Buttons.GoogleDark,
      onPressed: () => store.signInWithGoogle(),
    )
  );
}