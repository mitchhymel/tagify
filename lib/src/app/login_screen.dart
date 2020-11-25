
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/settings/lastfm_account_widget.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LastFmAccountWidget(),
        ],
      )
    ),
  );
}