

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class FirebaseAccountWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<FirebaseStore>(
    builder: (_, store, __) => !store.loggedIn ?
      ElevatedButton.icon(
        icon: Icon(FontAwesome.google),
        label: Text('Login with Google'),
        onPressed: () => store.signInWithGoogle(),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
      ) :
      CustomCard(
        child: Column(
          children: [
            Text(store.user.displayName),
            Container(
              height: 190,
              width: 190,
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(store.user.photoURL)
                )
              ),
            ),
            ElevatedButton(
              child: Text('Logout from Tagify'),
              onPressed: () => store.signOutWithGoogle(),
            )
          ],
        )
      )
  );
}