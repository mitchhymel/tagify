
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/settings/firebase_account_widget.dart';
import 'package:tagify/src/widgets/settings/info_widget.dart';
import 'package:tagify/src/widgets/settings/lastfm_account_widget.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Tagify',
                style: TextStyle(
                  fontSize: 36
                )
              ),
              Container(height: 5),
              Text('An app made with flutter to bulk tag songs on lastfm and make playlists on spotify based on tags. You have to login with LastFm to use this app.',
                style: TextStyle(
                  color: Colors.grey,
                )
              ),
              Container(height: 10),
              //LastFmAccountWidget(),
              FirebaseAccountWidget(),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 10,
            left: 10,
            child: InfoWidget(),
          )
        ],
      )
    ),
  );
}