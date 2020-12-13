
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:tagify/src/app/app_state.dart';

class LoginWithGoogleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer(builder: (_, watch, __) {
   final store = watch(firebaseProvider);
   return store.loggedIn ? Container() : SignInButton(
     Buttons.GoogleDark,
     onPressed: () => store.signInWithGoogle(),
   );
  });
}