import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/firebase/login_with_email_widget.dart';
import 'package:tagify/src/widgets/firebase/login_with_google_button.dart';

class FirebaseAccountWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer(builder: (_, watch, __) {
    final firebase = watch(firebaseProvider);

    if (!firebase.loggedIn) {
      return CustomCard(
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
              Text('By proceeding, you agree to our Terms of Use and confirm you have read our Privacy Policy... which don\'t exist currently because the app is under development',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          )
        )
      );
    }

    return CustomCard(
      child: Column(
        children: [
          if (firebase.user.email != null) Text(firebase.user.email),
          if (firebase.user.displayName != null) Text(firebase.user.displayName),
          if (firebase.user.photoURL != null) Container(
            height: 190,
            width: 190,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(firebase.user.photoURL)
              )
            ),
          ),
          ElevatedButton(
            child: Text('Logout from Tagify'),
            onPressed: () => firebase.signOut(),
          )
        ],
      )
    );
  });
}