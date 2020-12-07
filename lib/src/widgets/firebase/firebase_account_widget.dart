import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/firebase/login_with_email_widget.dart';
import 'package:tagify/src/widgets/firebase/login_with_google_button.dart';

class FirebaseAccountWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<FirebaseStore>(
    builder: (_, store, __) => !store.loggedIn ?
      CustomCard(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 400
          ),
          child: Column(
            children: [
              LoginWithEmailWidget(),
              Container(height: 20),
              Divider(
                color: Colors.grey,
                thickness: 1,
                endIndent: 20,
                indent: 20,
              ),
              Container(height: 20),
              LoginWithGoogleButton(),
              Container(height: 20),
              Text('By proceeding, you agree to our Terms of Use and confirm you have read our Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )
        )
      ) :
      CustomCard(
        child: Column(
          children: [
            if (store.user.email != null) Text(store.user.email),
            if (store.user.displayName != null) Text(store.user.displayName),
            if (store.user.photoURL != null) Container(
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
              onPressed: () => store.signOut(),
            )
          ],
        )
      )
  );
}