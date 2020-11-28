import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:tagify/src/spotify/secrets.dart';
import 'package:tagify/src/spotify/serializable_spotify_creds.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/utils/utils.dart';

class SpotifyStore extends ChangeNotifier {
  String _cachedCredsKey = 'CACHED_CREDS';
  spot.SpotifyApiCredentials _credentials;
  AuthorizationCodeGrant _grant;

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

  spot.SpotifyApi _spotify;
  spot.SpotifyApi get spotify => _spotify;

  spot.User _user;
  spot.User get user => _user;

  List<spot.PlaylistSimple> _playlists = [];
  List<spot.PlaylistSimple> get playlists => _playlists;

  bool get loggedIn => _spotify != null && _user != null;

  SpotifyStore() {
    _credentials =
        spot.SpotifyApiCredentials(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET);
    _grant = spot.SpotifyApi.authorizationCodeGrant(_credentials);
    _authUri =
        _grant.getAuthorizationUrl(Uri.parse(Utils.REDIRECT_URI), scopes: scopes);

    tryLoginFromCachedCreds();
  }

  Future<void> tryLoginFromCachedCreds() async {
    var creds = await _retrieveCredsFromCache();
    if (creds == null) {
      log('Failed to retrieve cached Spotify creds');
      return;
    }

    _spotify = spot.SpotifyApi(creds);
    await _afterLogin();
  }

  Future<void> loginFromRedirectUri(Uri responseUri) async {
    _responseUri = responseUri;
    _spotify = spot.SpotifyApi.fromAuthCodeGrant(_grant, _responseUri.toString());

    await _cacheCreds();
    await _afterLogin();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.remove(_cachedCredsKey);
    if (!res) {
      log('Failed to delete Spotify creds from cache');
    }

    _playlists.clear();
    _user = null;
    _spotify = null;
    notifyListeners();
  }

  ///
  /// Ensure our cached creds or whatever creds we just got are valid
  /// by fetching users data
  Future<bool> _ensureValidCreds() async {
    bool tryRefreshCreds = false;
    try {
      _user = await _spotify.me.get();
      return true;
    } catch (ex) {
      if (ex is AuthorizationException) {
        tryRefreshCreds = true;
      }
      else {
        logError('Exception when ensure valid creds: $ex');
        return false;
      }
    }

    if (tryRefreshCreds) {
      try {
        await _spotify.client.refreshCredentials();
      } catch (ex) {
        logError('Exception when trying to refresh creds: $ex');
        return false;
      }

      try {
        _user = await _spotify.me.get();
        return true;
      } catch (ex) {
        logError('Exception when trying to get me after refreshing creds: $ex');
        return false;
      }
    }

    return false;
  }

  Future<void> _afterLogin() async {
    var valid = await _ensureValidCreds();
    if (!valid) {
      return;
    }

    try {
      refreshPlaylists();
    } catch (ex) {
      logError('Exception when trying to fetch spotify user data: $ex');
    }

    notifyListeners();
  }

  Future<void> _cacheCreds() async {
    spot.SpotifyApiCredentials creds = await _spotify.getCredentials();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.setString(_cachedCredsKey, creds.toJson());
    if (!res) {
      log('Failed to save Spotify creds');
    }
  }

  Future<spot.SpotifyApiCredentials> _retrieveCredsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_cachedCredsKey)) {
      log('No Spotify cached creds found');
      return null;
    }

    String json = prefs.getString(_cachedCredsKey);
    var creds = SerializeableSpotifyApiCredentials.fromJson(json);
    return creds;
  }

  Future<void> refreshPlaylists() async {
    var results = await _spotify.playlists.me.all();
    _playlists = results.toList();
    notifyListeners();
  }
}
