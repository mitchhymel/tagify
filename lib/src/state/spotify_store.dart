import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:tagify/src/spotify/secrets.dart';
import 'package:tagify/src/spotify/serializable_spotify_creds.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/state/search_store.dart';
import 'package:tagify/src/utils/utils.dart';

// have global spotify api for non user uses
spot.SpotifyApi spotify = new spot.SpotifyApi(
    spot.SpotifyApiCredentials(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET));

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

  spot.User _user;
  spot.User get user => _user;

  List<spot.PlaylistSimple> _playlists = [];
  List<spot.PlaylistSimple> get playlists => _playlists.where(
      (p) => p.name.toLowerCase().contains(_filter.toLowerCase())).toList();
  spot.PlaylistSimple _selectedPlaylist;
  spot.PlaylistSimple get selectedPlaylist => _selectedPlaylist;

  bool _fetchingPlaylist = false;
  bool get fetchingPlaylist => _fetchingPlaylist;

  String _filter = '';
  String get filter => _filter;
  set filter(String other) {
    _filter = other;
    notifyListeners();
  }

  Map<String, List<String>> _playlistIdToTracks = {};
  Map<String, List<String>> get playlistIdToTracks => _playlistIdToTracks;

  spot.SpotifyApi _spotify;
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
        logError('Spotify - Exception when ensure valid creds: $ex');
        return false;
      }
    }

    if (tryRefreshCreds) {
      try {
        await _spotify.client.refreshCredentials();
      } catch (ex) {
        logError('Spotify - Exception when trying to refresh creds: $ex');
        return false;
      }

      try {
        _user = await _spotify.me.get();
        return true;
      } catch (ex) {
        logError('Spotify - Exception when trying to get me after refreshing creds: $ex');
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

  Future<void> _cacheCreds({spot.SpotifyApiCredentials creds}) async {
    if (creds == null) {
      creds = await _spotify.getCredentials();
    }
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

  Future<void> setSelectedAndEnsureCached(spot.PlaylistSimple other,
      EnsureCached cache
  ) async {
    _selectedPlaylist = other;
    _fetchingPlaylist = true;
    notifyListeners();

    if (_playlistIdToTracks.containsKey(_selectedPlaylist.id)) {
      log('Spotify playlist already fetched, using cached version');
      _fetchingPlaylist = false;
      notifyListeners();
      return;
    }

    _playlistIdToTracks[_selectedPlaylist.id] = [];
    log('Fetching tracks for spotify playlist "${other.name}"');
    var tracks = await _spotify.playlists.getTracksByPlaylistId(_selectedPlaylist.id).all();
    for (var track in tracks) {
      var item = TrackCacheItem.fromSpotifyTrack(track);
      cache([item]);
      _playlistIdToTracks[_selectedPlaylist.id].add(item.id);
      notifyListeners();
    }

    log('Finished fetching tracks for spotify playlist "${_selectedPlaylist.name}"');
    _fetchingPlaylist = false;
    notifyListeners();
  }

  Future<List<TrackCacheItem>> search(String query, int page) async {

    List<TrackCacheItem> results = [];
    var res = await spotify.search
      .get(query, types: [spot.SearchType.track])
      .getPage(25, page);
    res.forEach((p) {
      p.items.forEach((t) {
        if (t is spot.Track) {
          var track = TrackCacheItem.fromSpotifyTrack(t);
          results.add(track);
        }
      });
    });
    return results;
  }

  Future<List<TrackCacheItem>> getHistory(int page) async {
    List<TrackCacheItem> results = [];
    var res = await _spotify.me.recentlyPlayed();
    for (var p in res) {
      var track = await spotify.tracks.get(p.track.id);
      var item = TrackCacheItem.fromSpotifyTrack(track);
      results.add(item);
    }
    return results;
  }

}
