

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class FirebaseAccountWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<FirebaseStore>(
    builder: (_, store, __) => !store.loggedIn ?
      ElevatedButton(
        child: Text('Login with Google'),
        onPressed: () => store.signInWithGoogle(),
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