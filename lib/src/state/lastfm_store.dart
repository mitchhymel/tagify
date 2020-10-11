part of tagify;

class LastFmStore  extends ChangeNotifier {
  String _cachedCredsKey = 'LASTFM_CACHED_CREDS';

  LastFmApi _lastFm;
  LastFmApi get lastFm  => _lastFm;

  UserSession _userSession;
  UserSession get userSession => _userSession;

  bool get loggedIn => _userSession != null;

  LastFmStore() {
    _lastFm = new LastFmApi(LASTFM_API_KEY, LASTFM_SHARED_SECRET, 'tagify', logger: new LastFmConsoleLogger());

    tryLoginFromCachedCreds();
  }

  Future<bool> login(String userName, String password) async {
    var session = await _lastFm.loginWithUserNamePassword(userName, password);
    if (session == null) {
      print('lastfm: could not login with username password');
      return false;
    }

    _userSession = session;
    await _cacheCreds();
    await _afterLogin();
    return true;
  }

  Future<void> tryLoginFromCachedCreds() async {
    var creds = await _retrieveCredsFromCache();
    if (creds == null) {
      print('lastfm: failed to retrieve cached creds');
      return;
    }

    _userSession = creds;
    _lastFm.loginWithSessionKey(creds.key);

    await _afterLogin();
  }

  Future<void> _afterLogin() async {


    notifyListeners();
  }

  Future<void> logout() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.remove(_cachedCredsKey);
    if (!res) {
      print('lastfm: failed to delete creds from shared prefs');
    }

    _lastFm.logout();
    notifyListeners();
  }


  Future<void> _cacheCreds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.setString(_cachedCredsKey, _userSession.toString());
    if (!res) {
      print('lastfm: Failed to save creds');
    }
  }

  Future<UserSession> _retrieveCredsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_cachedCredsKey)) {
      print('lastfm: no cached creds found');
      return null;
    }

    String sessionJson = prefs.getString(_cachedCredsKey);
    UserSession session = UserSession.fromMap(jsonDecode(sessionJson));
    return session;
  }
}