
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/utils/utils.dart';

typedef SignInCallback = Future<String> Function(String, String);

class LoginWithEmailWidget extends HookWidget {

  Future<void> _onSubmit(BuildContext context,
      String email, String password, SignInCallback callback,
      {bool showSuccessSnackBar=false,}
  ) async {

    if (!EmailValidator.validate(email)) {
      Utils.showSnackBar(context, 'Please enter a valid email.', isError: true);
      return false;
    }

    if (password.isEmpty) {
      Utils.showSnackBar(context, 'Please enter a password', isError: true);
      return false;
    }

    String error = await callback(email, password);
    if (error != null) {
      Utils.showSnackBar(context, error, isError: true);
    }
    else if (showSuccessSnackBar){
      Utils.showSnackBar(context, 'Success!');
    }
  }

  @override
  Widget build(BuildContext context) {
    var emailController = useTextEditingController();
    var passController = useTextEditingController();
    return  Consumer<FirebaseStore>(
      builder: (_, store, __) => store.loggedIn ? Container() : Container(
        constraints: BoxConstraints(
          maxWidth: 400,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email'
              ),
            ),
            Container(height: 5),
            TextField(
              controller: passController,
              obscureText: true,
              onSubmitted: (x) => _onSubmit(context, emailController.text,
                passController.text, store.signInWithEmailPassword
              ),
              decoration: InputDecoration(
                hintText: 'Password'
              ),
            ),
            Container(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 10),
                ElevatedButton(
                  child: Text('Log in'),
                  onPressed: () => _onSubmit(context, emailController.text,
                      passController.text, store.signInWithEmailPassword),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(150, 40)),
                  )
                ),
                Container(width: 30),
                ElevatedButton(
                  child: Text('Sign up'),
                  onPressed: () => _onSubmit(context, emailController.text,
                      passController.text, store.signUpWithEmailPassword),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(150, 40)),
                  )
                ),
                Container(width: 10),
              ],
            ),
            Container(height: 5),
            Center(
              child: ElevatedButton(
                child: Text('Send password reset email'),
                onPressed: () => _onSubmit(context,
                  emailController.text,
                  'some non empty password',
                  (email, _) => store.sendResetPasswordEmail(email),
                  showSuccessSnackBar: true,
                )
              )
            )
          ],
        )
      ),

    );
  }
}