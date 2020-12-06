
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/firebase/firebase_account_widget.dart';
import 'package:tagify/src/widgets/settings/info_widget.dart';

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
              Text('An app to add tags to songs and create playlists on spotify from the tags.',
                style: TextStyle(
                  color: Colors.grey,
                )
              ),
              Container(height: 10),
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