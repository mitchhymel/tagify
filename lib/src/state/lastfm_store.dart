
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagify/src/lastfm/secrets.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/utils/utils.dart';


class LastFmStore  extends ChangeNotifier {
  String _cachedCredsKey = 'LASTFM_CACHED_CREDS';

  LastFmApi _api;
  LastFmApi get api  => _api;

  // User / Auth state
  UserSession _userSession;
  UserSession get userSession => _userSession;
  User _user;
  User get user => _user;
  bool get loggedIn => _userSession != null && _userSession.key != null &&
    _userSession.name != null;

  // App wide cache state
  Map<TrackCacheKey, TrackCacheEntry> _trackCache = {};
  Map<TrackCacheKey, TrackCacheEntry> get trackCache => _trackCache;
  Map<TrackCacheKey, bool> _favorites = {};
  Map<TrackCacheKey, bool> get favorites => _favorites;
  Map<TrackCacheKey, Set<String>> _trackToTags = {};
  Map<TrackCacheKey, Set<String>> get trackToTags => _trackToTags;
  void updateTrackToTags(bool isAdd, TrackCacheKey key, String tag) {
    Set<String> set;
    if (!_trackToTags.containsKey(key)) {
      set = new Set<String>();
    }
    else {
      set = _trackToTags[key];
    }

    if (isAdd) {
      set.add(tag);
    }
    else {
      set.remove(tag);
    }
    _trackToTags[key] = set;
    notifyListeners();
  }
  LinkedHashMap<TrackCacheKey, bool> _trackQueue = new LinkedHashMap();
  LinkedHashMap<TrackCacheKey, bool> get trackQueue => _trackQueue;

  // Recents screen state
  List<TrackCacheKey> _recents = [];
  List<TrackCacheKey> get recents => _recents;
  bool _recentsHasMore = false;
  bool get recentsHasMore => _recentsHasMore;
  bool _recentsFetching = false;
  bool get recentsFetching => _recentsFetching;
  TrackCacheKey _nowPlaying;
  TrackCacheKey get nowPlaying => _nowPlaying;

  // Search screen state
  String _trackQuery ='';
  String get trackQuery => _trackQuery;
  set trackQuery(String other) {
    _trackQuery = other;
    notifyListeners();
  }
  String _artistQuery = '';
  String get artistQuery => _artistQuery;
  set artistQuery(String other) {
    _artistQuery = other;
    notifyListeners();
  }
  bool _searching = false;
  bool get searching => _searching;
  bool _trackSearchHasMore = false;
  bool get trackSearchHasMore => _trackSearchHasMore;
  List<TrackCacheKey> _trackSearchResults = [];
  List<TrackCacheKey> get trackSearchResults => _trackSearchResults;

  // Tag screen state
  Map<String, Set<TrackCacheKey>> _tagToTracks = {};
  Map<String, Set<TrackCacheKey>> get tagToTracks => _tagToTracks;
  void updateTagToTracks(bool isAdd, String tag, TrackCacheKey key) {
    Set<TrackCacheKey> set;
    if (!_tagToTracks.containsKey(tag)) {
      set = new Set<TrackCacheKey>();
    }
    else {
      set = _tagToTracks[tag];
    }

    if (isAdd) {
      set.add(key);
    }
    else {
      set.remove(key);
    }
    _tagToTracks[tag] = set;

    if (set.isEmpty) {
      _tagToTracks.remove(tag);
    }
    notifyListeners();
  }
  bool _taggingTracks = false;
  bool get taggingTracks => _taggingTracks;
  String _tagsFilter = '';
  String get tagsFilter => _tagsFilter;
  set tagsFilter(String other) {
    _tagsFilter = other;
    notifyListeners();
  }
  bool _tagsHasMore = false;
  bool get tagsHasMore => _tagsHasMore;
  bool _tagsFetching = false;
  bool get tagsFetching => _tagsFetching;
  String _selectedTag;
  String get selectedTag => _selectedTag;
  set selectedTag(String other) {
    _selectedTag = other;
    notifyListeners();

    if (!_tagToTracks.containsKey(_selectedTag)) {
      refreshForTag(_selectedTag);
    }
  }
  Map<String, Set<Artist>> _tagToArtists = {};
  Map<String, Set<Artist>> get tagToArtists => _tagToArtists;
  Map<String, Set<Album>> _tagToAlbums = {};
  Map<String, Set<Album>> get tagToAlbums => _tagToAlbums;


  // Queue screen state
  int _totalToTag = 1;
  int get totalToTag => _totalToTag;
  int _taggedSoFar = 0;
  int get taggedSoFar => _taggedSoFar;
  Set<String> _tagsToTagTracksWith = new Set<String>();
  Set<String> get tagsToTagTracksWith => _tagsToTagTracksWith;
  void addTagToTagList(String tag) {
    _tagsToTagTracksWith.add(tag);
    notifyListeners();
  }
  void removeTagFromTagList(String tag) {
    _tagsToTagTracksWith.remove(tag);
    notifyListeners();
  }


  LastFmStore() {
    _api = new LastFmApi(LASTFM_API_KEY, LASTFM_SHARED_SECRET, 'tagify',
      //logger: LastFmConsoleLogger()
    );

    tryLoginFromCachedCreds();
  }

  //#region auth

  Future<bool> login(String userName, String password) async {
    var session = await _api.loginWithUserNamePassword(userName, password);
    if (session == null) {
      log('LastFm could not login with username password');
      return false;
    }

    _userSession = session;
    await _cacheCreds();
    await _afterLogin();
    return true;
  }

  Future<bool> loginFromSession(String session) async {
    var resp = await _api.auth.getSession(session);
    if (!resp.isSuccess()) {
      log('Could not login from session: $resp');
      return false;
    }

    _userSession = resp.data.session;
    _api.loginWithSessionKey(_userSession.key);
    await _cacheCreds();
    await _afterLogin();
    return true;
  }

  Future<void> tryLoginFromCachedCreds() async {
    var creds = await _retrieveCredsFromCache();
    if (creds == null) {
      log('Unable to login to LastFm from cached credentials');
      return;
    }

    _userSession = creds;
    _api.loginWithSessionKey(creds.key);
    log('Successfully logged in to LastFm with cached credentials');


    await _afterLogin();
  }

  Future<void> _afterLogin() async {

    await userRefresh();
    // await recentsRefresh();
    // await tagsFetch(1); //dont want to lose tags to tracks from recents

    notifyListeners();
  }

  Future<void> logout() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.remove(_cachedCredsKey);
    if (!res) {
      log('Failed to delete LastFm credentials from cache');
    }

    _api.logout();
    log('Successfully deleted LastFm credentials from cache');
    _userSession = null;
    notifyListeners();
  }


  Future<void> _cacheCreds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.setString(_cachedCredsKey, jsonEncode(_userSession.toJson()));
    if (!res) {
      log('Failed to save LastFm credentials to cache');
    }
  }

  Future<UserSession> _retrieveCredsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_cachedCredsKey)) {
      log('Failed to find LastFm credentials in cache');
      return null;
    }

    String sessionJson = prefs.getString(_cachedCredsKey);
    UserSession session = UserSession.fromJson(jsonDecode(sessionJson));
    return session;
  }

  Future<void> userRefresh() async {
    var res = await _api.user.getInfo(_userSession.name);
    if (!res.isSuccess()) {
      log('Failed to get user info: $res');
      return;
    }

    _user = res.data.user;
    notifyListeners();
  }

  //#endregion auth

  //#region recents
  Future<void> recentsRefresh() async {
    _recents = [];
    notifyListeners();

    await recentsFetch(1, 25, refreshCache: true);
  }

  Future<void> recentsFetch(int page, int pageLimit, {
    bool refreshCache=false,
  }) async {
    if (_recentsFetching) {
      log('Already fetching requests... returning early');
      return;
    }

    log('Fetching recents for page $page with a limit of $pageLimit');

    _recentsFetching = true;
    notifyListeners();

    var res = await api.user.getRecentTracks(
      userSession.name,
      page: page,
      limit: pageLimit,
    );

    if (!res.isSuccess()) {
      logError('Error when fetching recents: $res');
      _recentsFetching = false;
      notifyListeners();
      return;
    }

    var newRecents = res.data.recenttracks.items;

    // adds currently playing track as 1 more than the limit we request
    _recentsHasMore = (newRecents.length == pageLimit + 1);

    // the currently playing track will always be the first
    if (newRecents.isNotEmpty && newRecents.first.nowPlaying) {
      var newKey = TrackCacheKey.fromTrack(newRecents.first);
      var cached = await _ensureCached(newKey,
        refreshCache: refreshCache,
      );
      if (cached != null) {
        _nowPlaying = newKey;
      }
      newRecents.removeAt(0);
    }
    else {
      _recentsHasMore = (newRecents.length == pageLimit);
    }

    List<TrackCacheKey> keys = [];
    for (Track track in newRecents) {
      var key = new TrackCacheKey.fromTrack(track);
      var cached = await _ensureCached(key,
        refreshCache: refreshCache,
      );
      if (cached != null) {
        keys.add(key);
      }
    }

    _recents.addAll(keys);

    _recentsFetching = false;
    notifyListeners();
    notifyListeners();
  }

  //#endregion recents

  //#region tags
  Future<void> tagsRefresh() async {
    _tagToTracks = {};
    _selectedTag = null;
    notifyListeners();
    await tagsFetch(1);
  }

  Future<void> tagsFetch(int page, {int limit=25}) async {
    _tagsFetching = true;
    notifyListeners();

    log('GetTopTags with results for page $page with limit $limit');

    var response = await api.user.getTopTags(userSession.name);

    if (!response.isSuccess()) {
      logError('Error when fetching tags: $response');
      _tagsFetching = false;
      notifyListeners();
      return;
    }

    List<Tag> tags = response.data.toptags.items;
    _tagsHasMore = tags.length == limit;
    for (Tag tag in tags) {
      await refreshForTag(tag.name);
    }

    log('GetTopTags found ${tags.length} results');
    _tagsFetching = false;
    notifyListeners();
  }

  Future<void> refreshForTag(String tag, {int page=1, int limit=25}) async {
    _tagsFetching = true;
    notifyListeners();

    var trackResp = await api.user.getPersonalTags(
      userSession.name, tag, 'track',
      page: page,
      limit: limit
    );
    var trackTags = trackResp.data.taggings.tracks.items;
    var trackCacheKeys = await _ensureTracksCached(trackTags);
    for (var key in trackCacheKeys) {
      updateTrackToTags(true, key, tag);
      updateTagToTracks(true, tag, key);
    }

    // var artistResp = await api.user.getPersonalTags(
    //     userSession.name, tag, 'artist');
    // var artistIds = artistResp.data.taggings.artists.items
    //     .map((e) => e.name).toSet();
    // var artistTags = artistResp.data.taggings.artists.items;
    // artistTags.retainWhere((x) => artistIds.remove(x.name));
    //
    // var albumResp = await api.user.getPersonalTags(
    //     userSession.name, tag, 'album');
    // var albumIds = albumResp.data.taggings.albums.items
    //     .map((e) => e.name).toSet();
    // var albumTags = albumResp.data.taggings.albums.items;
    // albumTags.retainWhere((x) => albumIds.remove(x.name));

    // var tagResult = new TagResult(
    //   artists: artistTags,
    //   albums: albumTags,
    //   tracks: trackCacheKeys,
    // );

    _tagsFetching = false;
    notifyListeners();
  }

  Future<void> changeLikeOnTrack(TrackCacheKey key, bool isLike) async {

    String op = isLike ? "Like" : "Unlike";
    log('$op track "${key.toLogStr()}"');
    var res = isLike ? await _api.track.love(key.artist, key.name)
      : await _api.track.unlove(key.artist, key.name);
    if (res.hasError()) {
      logError('Error while trying to $op track: $res');
      return;
    }

    _favorites[key] = isLike;

    notifyListeners();
  }
  //#endregion tags

  //#region search
  Future<void> searchRefresh() async {
    _trackSearchResults = [];
    notifyListeners();
    await searchTrack(1, refreshCache: true);
  }

  Future<void> searchTrack(int page, {int limit=25, bool refreshCache=false}) async {
    if (_trackQuery.isEmpty && _artistQuery.isEmpty) {
      log('Search track query is empty, so will not make a request');
      return;
    }

    String trackToUse = _trackQuery;
    if (trackToUse.isEmpty && _artistQuery.isNotEmpty) {
      trackToUse = ' ';
    }

    _searching = true;
    notifyListeners();

    log('Searching for track "$trackToUse", artist "$_artistQuery", with results for page $page with limit $limit');
    LastFmResponse response;
    if (_artistQuery.isEmpty) {
      response = await api.track.search(trackToUse,
        page: page,
        limit: limit
      );
    }
    else {
      response = await api.track.search(trackToUse,
        artist: _artistQuery,
        page: page,
        limit: limit
      );
    }

    if (response.error != null) {
      logError('Error when searching: $response');
      _searching = false;
      notifyListeners();
      return;
    }

    List<Track> tracks = response.data.results.tracks.items;

    var cachedTracks = await _ensureTracksCached(
      tracks,
      refreshCache: refreshCache,
    );

    _trackSearchResults.addAll(cachedTracks);
    _trackSearchHasMore = tracks.length == limit;
    _searching = false;
    log('Search found ${tracks.length} results');
    notifyListeners();
  }
  //#endregion search

  //#region queue
  bool addTrackToQueue(TrackCacheKey key) {
    bool trackNotInQueue = _trackQueue.containsKey(key);
    _trackQueue[key] = false;
    if (trackNotInQueue) {
      resetProgress();
      notifyListeners();
      return true;
    }

    notifyListeners();
    return true;
  }

  void removeTrackFromQueue(TrackCacheKey key) {
    _trackQueue.remove(key);
    resetProgress();
    notifyListeners();
  }

  void clearQueue() {
    _trackQueue = new LinkedHashMap();
    resetProgress();
    notifyListeners();
  }

  void resetProgress() {
    _totalToTag = 1;
    _taggedSoFar = 0;
    notifyListeners();
  }

  Future<void> removeTagsFromTracks() async {
    if (_tagsToTagTracksWith.isEmpty) {
      return;
    }

    _taggingTracks = true;
    notifyListeners();

    _totalToTag = _trackQueue.keys.length;
    _taggedSoFar = 0;
    log('Beginning to remove tags from $_totalToTag tracks');
    notifyListeners();

    for (var entry in _trackQueue.entries) {
      for (var tag in _tagsToTagTracksWith) {
        var success = await removeTagFromTrack(entry.key, tag);
        if (!success) {
          // in error case, removeTagFromTrack will log error
          _taggingTracks = false;
          notifyListeners();
          return;
        }

        _trackQueue[entry.key] = true;
        _taggedSoFar ++;
        notifyListeners();
      }
    }

    log('Finished removing tags from tracks');
    _taggingTracks = false;
    notifyListeners();
  }

  Future<void> tagTracks() async {
    if (_tagsToTagTracksWith.isEmpty) {
      return;
    }

    _taggingTracks = true;
    notifyListeners();

    _totalToTag = _trackQueue.keys.length;
    _taggedSoFar = 0;
    String tagsStr = _tagsToTagTracksWith.join(',');
    log('Beginning to tag $_totalToTag tracks with "$tagsStr"');
    notifyListeners();

    for (var entry in _trackQueue.entries) {
      if (!_taggingTracks) {
        break;
      }

      bool success = await addTagsToTrack(entry.key, _tagsToTagTracksWith);

      if (!success) {
        _taggingTracks = false;
        notifyListeners();
        return;
      }

      _trackQueue[entry.key] = true;
      _taggedSoFar ++;
      notifyListeners();
    }

    log('Finished tagged tracks');
    _taggingTracks = false;
    notifyListeners();
  }

  void stopTaggingTracks() {
    _taggingTracks = false;
    notifyListeners();
  }

  void addAlbumToQueue(Album album) {

  }

  void addArtistToQueue(Artist artist) {

  }


  //#endregion queue

  //#region trackcache

  Future<List<TrackCacheKey>> _ensureTracksCached(List<Track> tracks, {
    bool refreshCache=false,
  }) async {
    List<TrackCacheKey> keys = [];
    for (var track in tracks) {
      var newKey = new TrackCacheKey.fromTrack(track);
      var entry = await _ensureCached(newKey, refreshCache: refreshCache);
      if (entry != null) {
        keys.add(newKey);
      }
    }

    return keys;
  }

  Future<TrackCacheEntry> _ensureCached(TrackCacheKey key, {
    bool refreshCache=false
  }) async {
    if (!refreshCache && _trackCache.containsKey(key)) {
      return _trackCache[key];
    }

    return await _fetchAndCacheTrack(key);
  }

  Future<TrackCacheEntry> _fetchAndCacheTrack(TrackCacheKey key) async {
    String artist = key.artist;
    String name = key.name;
    String trackIdentifier = '"$name" by "$artist"';
    log('Fetching info for track $trackIdentifier');

    var trackInfoRes = await _api.track.getInfo(
      artist: artist,
      track: name,
      userName: _user.name,
    );

    if (trackInfoRes.hasError()) {
      logError('Error when fetching info for track $trackIdentifier: $trackInfoRes');
      return null;
    }

    Track track = trackInfoRes.data.track;
    String imageUrl = Utils.getImageUrl(null, track);
    if (imageUrl == null) {
      // sometimes tracks will not have an image url... fetch the info
      // on the album to ensure we have it... but in some cases
      // the track is not even associated with an album so we just have
      // to search and hope for the best
      if (track.album == null) {
        var searchRes = await _api.track.search(
          name,
          artist: artist
        );

        if (searchRes.hasError()) {
          logError('Error when searching for $trackIdentifier: $searchRes');
          return null;
        }

        var trackMatches = searchRes.data.results.tracks.items;
        for (var trackMatch in trackMatches) {
          imageUrl = Utils.getImageUrl(null, trackMatch);
          if (imageUrl != null) {
            break;
          }
        }
      }
      else {
        var albumInfoRes = await _api.album.getInfo(
          artist: artist,
          album: track.album.name,
        );

        if (albumInfoRes.hasError()) {
          logError('Error when fetching info for ${track.album.name} by $artist: $trackInfoRes');
          return null;
        }

        imageUrl = albumInfoRes.data.album.image[Utils.IMAGE_QUALITY].text;
      }

      // if we're here and we STILL haven't set imageUrl to a valid url
      // then we definitely could not find it
      if (imageUrl == null) {
        logError('Could not find album art for $trackIdentifier');
      }
    }

    log('Fetching tags for track $trackIdentifier');
    var tagsRes = await _api.track.getTags(
      artist: artist,
      track: name,
      user: _user.name,
    );

    if (tagsRes.hasError()) {
      logError('Error when fetching tags for track $trackIdentifier: $tagsRes');
      return null;
    }

    List<String> tags = [];
    if (!(tagsRes.data.tags.items == null)) {
      tags = tagsRes.data.tags.items.map((x) => x.name).toList();
    }

    var entry = new TrackCacheEntry(
      key: key,
      album: track.album == null ? null : track.album.name,
      name: name,
      artist: artist,
      imageUrl: imageUrl,
      playCount: track.userplaycount,
    );

    // finally, update caches
    _trackCache[key] = entry;
    _favorites[key] = track.userloved;
    tags.forEach((x) {
      updateTrackToTags(true, key, x);
      updateTagToTracks(true, x, key);
    });

    return entry;
  }

  Future<bool> addTagsToTrack(TrackCacheKey key, Set<String> tags) async {
    TrackCacheEntry entry = _trackCache[key];
    String artist = entry.artist;
    String name = entry.name;
    String tagsStr = tags.join(',');
    log('Tagging "$name" by "$artist" with "$tagsStr"');
    var res = await api.track.addTags(
      artist,
      name,
      tags.toList(),
    );

    if (res.hasError()) {
      logError('Error while trying to tag tracks: $res');
      return false;
    }

    tags.forEach((x) {
      updateTrackToTags(true, key, x);
      updateTagToTracks(true, x, key);
    });

    notifyListeners();
    return true;
  }

  Future<bool> removeTagFromTrack(TrackCacheKey key, String tag) async {

    TrackCacheEntry entry = _trackCache[key];
    String artist = entry.artist;
    String track = entry.name;
    String entryId = '"$track" by "$artist"';
    log('Removing tag "$tag" from $entryId');
    var res = await _api.track.removeTag(
      entry.artist,
      entry.name,
      tag,
    );
    if (res.hasError()) {
      logError('Error when trying to remove tag "$tag" from $entryId');
      return false;
    }

    updateTrackToTags(false, key, tag);
    updateTagToTracks(false, tag, key);

    log('Removed tag "$tag" from $entryId');
    notifyListeners();
    return true;
  }


  //#endregion
}