
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/state/spotify_store.dart';

typedef IsInCacheCallback = bool Function(String);

class FirebaseStore extends ChangeNotifier {

  static const _GET_TAGS = 'getTags';
  static const _ADD_TAGS = 'addTags';
  static const _REMOVE_TAGS = 'removeTags';
  static const _TAGS = 'tags';
  static const _TRACKS = 'tracks';
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  User _user;
  User get user => _user;

  bool get loggedIn => _user != null;

  Map<String, Set<String>> _tagToTracks = {};
  Map<String, Set<String>> get tagToTracks => _tagToTracks;
  List<String> get filteredTags => _tagToTracks.keys.where((x) =>
      x.toLowerCase().contains(_tagsFilter.toLowerCase())).toList();
  Map<String, Set<String>> _trackToTags = {};
  Map<String, Set<String>> get trackToTags => _trackToTags;

  bool _fetching = false;
  bool get fetching => _fetching;

  String _tagsFilter = '';
  String get tagsFilter => _tagsFilter;
  set tagsFilter(String other) {
    _tagsFilter = other;
    notifyListeners();
  }

  String _selectedTag;
  String get selectedTag => _selectedTag;
  set selectedTag(String other) {
    _selectedTag = other;
    notifyListeners();
  }

  Map<String, TrackCacheItem> _trackCache = {};
  Map<String, TrackCacheItem> get trackCache => _trackCache;

  void addToCache(TrackCacheItem item) {
    _trackCache[item.id] = item;
    notifyListeners();
  }

  void addAllToCache(List<TrackCacheItem> items) {
    items.forEach((x) => addToCache(x));
  }

  FirebaseStore() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    if (kDebugMode) {
      _functions.useFunctionsEmulator(origin: 'http://localhost:5001');
    }

    if (_auth.currentUser != null) {
      _user = _auth.currentUser;
      notifyListeners();

      await _afterLogin();
    }
  }

  Future<String> signUpWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      _user = userCred.user;
      await _afterLogin();
      notifyListeners();
    } catch (ex) {
      return 'Error when signing up with email and password: $ex';
    }

    return null;
  }

  Future<String> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      _user = userCred.user;
      await _afterLogin();
      notifyListeners();
    } catch (ex) {
      return 'Error when signing in with email and password: $ex';
    }

    return null;
  }

  Future<String> sendResetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (ex) {
      return 'Error when trying to send password reset email: $ex';
    }

    return null;
  }

  Future<bool> signInWithGoogle() async {

    final GoogleSignInAccount gsa = await _googleSignIn.signIn();
    final GoogleSignInAuthentication gsAuth = await gsa.authentication;
    final AuthCredential cred = GoogleAuthProvider.credential(
      accessToken: gsAuth.accessToken,
      idToken: gsAuth.idToken,
    );

    final UserCredential userCred = await _auth.signInWithCredential(cred);
    final User user = userCred.user;

    if (user != null) {
      // cache in sharedpreferences;
      _user = user;
    }

    await _afterLogin();
    notifyListeners();
    return true;
  }

  Future<bool> signOut() async {

    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (ex) {
      log('Error when signing out of google: $ex');
    }

    await _auth.signOut();

    // clear sharedpreferences
    logStore.clear();
    _user = null;
    notifyListeners();

    return true;
  }

  Future<void> _afterLogin() async {
    await getTags();
  }

  Future<bool> getTags() async {
    _fetching = true;
    _tagToTracks = {};
    _trackToTags = {};
    notifyListeners();

    bool success = true;
    var callable = _functions.httpsCallable(_GET_TAGS);

    try {
      final results = await callable.call();
      Map<String, List<dynamic>> data = Map<String, List<dynamic>>.from(results.data);
      data.entries.forEach((e) {
        _tagToTracks[e.key] = e.value.map((x) => x.toString()).toSet();
      });

      for (var e in _tagToTracks.entries) {
        for (var track in e.value) {
          if (!_trackToTags.containsKey(track)) {
            _trackToTags[track] = new Set<String>();
          }

          _trackToTags[track].add(e.key);
        }

        for (var track in _trackToTags.keys) {
          if (!_trackCache.containsKey(track)) {
            try {
              var t = await spotify.tracks.get(track);
              _trackCache[track] = TrackCacheItem.fromSpotifyTrack(t);
            }
            catch (ex) {
              logError('Error when fetching tags $ex');
              success = false;
              break;
            }
          }
        }
      }

    } catch (ex) {
      logError('Error when fetching tags: $ex');
      success = false;
    }

    // log(_tagToTracks);
    // log(_trackToTags);

    if (_tagToTracks.isNotEmpty) {
      _selectedTag = _tagToTracks.keys.first;
    }
    _fetching = false;
    notifyListeners();
    return success;
  }

  Future<bool> addTags(Set<String> tracks, Set<String> tags) async {
    return updateTags(true, tracks, tags);
  }

  Future<bool> removeTags(Set<String> tracks, Set<String> tags) async {
    return updateTags(false, tracks, tags);
  }

  Future<bool> updateTags(bool add, Set<String> tracks, Set<String> tags) async {
    _fetching = true;
    notifyListeners();

    bool success = true;
    String endpoint = add ? _ADD_TAGS : _REMOVE_TAGS;
    var callable = _functions.httpsCallable(endpoint);
    String op = add ? 'add' : 'remove';

    try {
      // Update state before making call
      var beforeTrack = {}..addAll(_trackToTags);
      var beforeTags = {}..addAll(_tagToTracks);
      tracks.forEach((x) {
        if (add) {
          if (!_trackToTags.containsKey(x)) {
            _trackToTags[x] = new Set<String>();
          }

          _trackToTags[x].addAll(tags);
        }
        else {
          _trackToTags[x].removeAll(tags);
        }
      });
      tags.forEach((x) {
        if (add) {
          if (!_tagToTracks.containsKey(x)) {
            _tagToTracks[x] = new Set<String>();
          }

          _tagToTracks[x].addAll(tracks);
        }
        else {
          _tagToTracks[x].removeAll(tracks);
        }
      });

      notifyListeners();

      final results = await callable.call(<String, dynamic>{
        _TRACKS: tracks.toList(),
        _TAGS: tags.toList(),
      });
      if (results.data == true) {
        log('Successfully $op tags $tags from $tracks');
      }
      else {
        logError('Error when $op tags: ${results.data}');
        //revert state
        _trackToTags = beforeTrack;
        _tagToTracks = beforeTags;
        success = false;
      }
    } catch (ex) {
      logError('Error when $op tags: $ex');
      success = false;
    }

    _fetching = false;
    notifyListeners();
    return success;
  }
}