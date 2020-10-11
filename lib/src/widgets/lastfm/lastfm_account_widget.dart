part of tagify;

class LastFmAccountWidget extends StatefulWidget {

  @override
  State createState() => LastFmAccountWidgetState();
}

class LastFmAccountWidgetState extends State<LastFmAccountWidget> {

  TextEditingController _userController;
  TextEditingController _passController;

  @override
  void initState() {
    super.initState();

    _userController = new TextEditingController();
    _passController = new TextEditingController();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, child) { 

      if (!store.loggedIn) {
        return Column(
          children: [
            TextField(
              showCursor: true,
              autofocus: false,
              textAlign: TextAlign.center,
              controller: _userController,
              decoration: InputDecoration(
                hintText: 'Username',
              ),
            ),
            TextField(
              showCursor: true,
              autofocus: false,
              textAlign: TextAlign.center,
              controller: _passController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              )
            ),
            RaisedButton(
              child: Text('Login'),
              onPressed: () async {
                String userName = _userController.text;
                String password = _passController.text;

                if (userName == null) {
                  print('username is null');
                  return;
                }

                if (password == null) {
                  print('password is null');
                  return;
                }
                await store.login(userName, password);
              },
            )
          ],
        );
      }

      return Column(
        children: [
          Container(
            height: 190,
            width: 190,
            child: Text(store.userSession.userName),
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
              // image: DecorationImage(
              //   fit: BoxFit.fill,
              //   image: NetworkImage(store.user.images[0].url)
              // )
            ),
          ),
           RaisedButton(
            child: Text('Logout from Lastfm'),
            onPressed: () => store.logout()
          ),
        ]
      );
    }
  );
}
