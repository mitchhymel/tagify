part of tagify;

class SpotifyStore extends ChangeNotifier {
  String _cachedCredsKey = 'CACHED_CREDS';
  SpotifyApiCredentials _credentials;
  AuthorizationCodeGrant _grant;
  final String _redirectUri = 'https://localhost/callback'; //'tagify://spotifycallback';
  final List<String> scopes = [
    'user-library-read',
    'user-read-recently-played',
    'user-read-currently-playing',
    'playlist-read-collaborative',
    'playlist-modify-public',
    'playlist-read-private',
    'playlist-modify-private',
  ];
  Uri _authUri;
  Uri get authUri => _authUri;

  Uri _responseUri;
  Uri get responseUri => _responseUri;
  set responseUri(Uri other) {
    _responseUri = other;
    notifyListeners();
  }

  SpotifyApi _spotify;
  SpotifyApi get spotify => _spotify;

  User _user;
  User get user => _user;

  List<PlaylistSimple> _playlists = [];
  List<PlaylistSimple> get playlists => _playlists;

  bool get loggedIn => _spotify != null && _user != null;

  SpotifyStore() {
    _credentials =
        SpotifyApiCredentials(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET);
    _grant = SpotifyApi.authorizationCodeGrant(_credentials);
    _authUri =
        _grant.getAuthorizationUrl(Uri.parse(_redirectUri), scopes: scopes);
    //print(_authUri);

    tryLoginFromCachedCreds();
  }

  Future<void> tryLoginFromCachedCreds() async {
    var creds = await _retrieveCredsFromCache();
    if (creds == null) {
      print('failed to retrieve cached creds');
      return;
    }

    _spotify = SpotifyApi(creds);
    await _afterLogin();
  }

  Future<void> loginFromRedirectUri(Uri responseUri) async {
    _responseUri = responseUri;
    _spotify = SpotifyApi.fromAuthCodeGrant(_grant, _responseUri.toString());

    await _cacheCreds();
    await _afterLogin();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.remove(_cachedCredsKey);
    if (!res) {
      print('failed to delete creds from shared prefs');
    }

    _playlists.clear();
    _user = null;
    _spotify = null;
    notifyListeners();
  }

  Future<void> _afterLogin() async {

    try {
      _user = await _spotify.me.get();
      refreshPlaylists();
    } catch (ex) {
      print('Exception when trying to fetch spotify user: $ex');
    }

    notifyListeners();
  }

  Future<void> _cacheCreds() async {
    SpotifyApiCredentials creds = await _spotify.getCredentials();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(creds.toJson());
    bool res = await prefs.setString(_cachedCredsKey, creds.toJson());
    if (!res) {
      print('Failed to save creds');
    }
  }

  Future<SpotifyApiCredentials> _retrieveCredsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_cachedCredsKey)) {
      print('no cached creds found');
      return null;
    }

    String json = prefs.getString(_cachedCredsKey);
    var creds = SerializeableSpotifyApiCredentials.fromJson(json);
    return creds;
  }

  Future<void> refreshPlaylists() async {
    var results = await _spotify.playlists.me.all();
    _playlists = results.toList();
    print(_playlists.length);
    notifyListeners();
  }
}