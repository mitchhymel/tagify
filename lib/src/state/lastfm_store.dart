
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tagify/src/lastfm/secrets.dart';
import 'package:tagify/src/state/log_store.dart';

class TagResult {
  final List<Artist> artists;
  final List<TrackCacheEntry> tracks;
  final List<Album> albums;

  TagResult({
    @required this.artists,
    @required this.tracks,
    @required this.albums,
  });
}

class TrackCacheEntry{
  List<String> tags;
  Track track;
  TrackCacheEntry({
    this.tags,
    this.track
  });
}

class TrackCacheKey {
  final String name;
  final String artist;
  TrackCacheKey({
    @required this.name,
    @required this.artist,
  });

  TrackCacheKey.fromTrack(Track track) :
      name=track.name,
      artist=track.artist.name??track.artist.text;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (!(other is TrackCacheEntry)) {
      return false;
    }

    return name.compareTo(other) == 0 &&
      artist.compareTo(other) == 0;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}

class QueueEntry<T> {

  final T data;
  bool processed;
  QueueEntry({
    this.data,
    this.processed=false,
  });
}


class LastFmStore  extends ChangeNotifier {
  String _cachedCredsKey = 'LASTFM_CACHED_CREDS';

  LastFmApi _api;
  LastFmApi get api  => _api;

  UserSession _userSession;
  UserSession get userSession => _userSession;
  User _user;
  User get user => _user;

  bool get loggedIn => _userSession != null && _userSession.key != null &&
    _userSession.name != null;

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
    await recentsRefresh();
    await tagsRefresh();

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

  TrackCacheKey _nowPlaying;
  TrackCacheEntry get nowPlaying => _trackCache[_nowPlaying];

  bool _recentsHasMore = false;
  bool get recentsHasMore => _recentsHasMore;

  bool _recentsFetching = false;
  bool get recentsFetching => _recentsFetching;

  Future<void> recentsRefresh() async {
    _recentTracks = [];
    notifyListeners();

    await recentsFetch(1, 5, refreshCache: true);
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
      log('Error when fetching recents');
      _recentsFetching = false;
      notifyListeners();
      return;
    }

    var newRecents = res.data.recenttracks.items;

    // adds currently playing track as 1 more than the limit we request
    _recentsHasMore = newRecents.length == pageLimit + 1;

    // the currently playing track will always be the first
    if (newRecents.isNotEmpty && newRecents.first.nowPlaying) {
      var newKey = TrackCacheKey.fromTrack(newRecents.first);
      var cached = await _ensureCached(newKey,
        refreshCache: refreshCache,
        augmentCache: newRecents.first
      );
      if (cached != null) {
        _nowPlaying = newKey;
      }
      newRecents.removeAt(0);
    }
    else {
      _recentsHasMore = newRecents.length == pageLimit;
    }

    List<TrackCacheKey> keys = [];
    for (Track track in newRecents) {
      var key = new TrackCacheKey.fromTrack(track);
      var cached = await _ensureCached(key,
        refreshCache: refreshCache,
        augmentCache: track,
      );
      if (cached != null) {
        keys.add(key);
      }
    }

    _recentTracks.addAll(keys);

    _recentsFetching = false;
    notifyListeners();
    notifyListeners();
  }


  //#endregion recents

  //#region tags
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

  List<Tag> _tags = [];
  List<Tag> get tags => _tags.where((x) => x.name.toLowerCase()
      .contains(_tagsFilter.toLowerCase())).toList();

  Map<Tag, TagResult> _tagsCache = {};
  Map<Tag, TagResult> get tagsCache => _tagsCache;

  Tag _tagsSelected;
  Tag get tagsSelected => _tagsSelected;
  set tagsSelected(Tag other) {
    _tagsSelected = other;
    notifyListeners();

    if (!_tagsCache.containsKey(_tagsSelected)) {
      refreshForTag(_tagsSelected);
    }
    else {

    }
  }
  TagResult get tagsSelectedResult => _tagsCache[_tagsSelected];

  Future<void> tagsRefresh() async {
    _tags = [];
    _tagsSelected = null;
    notifyListeners();
    await tagsFetch(1);
  }

  Future<void> tagsFetch(int page, {int limit=25}) async {
    _tagsFetching = true;
    notifyListeners();

    log('GetTopTags with results for page $page with limit $limit');

    var response = await api.user.getTopTags(userSession.name);

    _tagsFetching = false;
    notifyListeners();

    if (!response.isSuccess()) {
      log('Error when fetching tags: $response');
      return;
    }

    List<Tag> tags = response.data.toptags.items;
    _tags.addAll(tags);
    _tagsHasMore = tags.length == limit;

    log('GetTopTags found ${tags.length} results');
    notifyListeners();
  }

  Future<void> refreshForTag(Tag tag) async {
    _tagsFetching = true;
    notifyListeners();

    var trackResp = await api.user.getPersonalTags(
        userSession.name, tag.name, 'track');
    var trackTags = trackResp.data.taggings.tracks.items;
    var trackCacheEntries = await _ensureTracksCached(trackTags);

    var artistResp = await api.user.getPersonalTags(
        userSession.name, tag.name, 'artist');
    var artistIds = artistResp.data.taggings.artists.items
        .map((e) => e.name).toSet();
    var artistTags = artistResp.data.taggings.artists.items;
    artistTags.retainWhere((x) => artistIds.remove(x.name));

    var albumResp = await api.user.getPersonalTags(
        userSession.name, tag.name, 'album');
    var albumIds = albumResp.data.taggings.albums.items
        .map((e) => e.name).toSet();
    var albumTags = albumResp.data.taggings.albums.items;
    albumTags.retainWhere((x) => albumIds.remove(x.name));

    var tagResult = new TagResult(
      artists: artistTags,
      albums: albumTags,
      tracks: trackCacheEntries,
    );

    _tagsCache.putIfAbsent(tag, () => tagResult);

    _tagsFetching = false;
    notifyListeners();
  }
  //#endregion tags

  //#region search
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

  List<Track> _searchTracks = [];
  List<Track> get searchTracks => _searchTracks;

  bool _searching = false;
  bool get searching => _searching;

  bool _searchHasMore = false;
  bool get searchHasMore => _searchHasMore;

  Future<void> searchRefresh() async {
    _searchTracks = [];
    notifyListeners();
    await searchTrack(1);
  }

  Future<void> searchTrack(int page, {int limit=25}) async {
    if (_trackQuery.isEmpty) {
      log('Search track query is empty, so will not make a request');
      return;
    }

    _searching = true;
    notifyListeners();

    log('Searching for track "$_trackQuery", artist "$_artistQuery", with results for page $page with limit $limit');
    LastFmResponse response;
    if (_artistQuery.isEmpty) {
      response = await api.track.search(_trackQuery,
        page: page,
        limit: limit
      );
    }
    else {
      response = await api.track.search(_trackQuery,
        artist: _artistQuery,
        page: page,
        limit: limit
      );
    }

    _searching = false;
    notifyListeners();

    if (response.error != null) {
      log('Error when searching: $response');
      return;
    }

    List<Track> tracks = response.data.results.tracks.items;
    _searchTracks.addAll(tracks);
    _searchHasMore = tracks.length == limit;

    log('Search found ${tracks.length} results');
    notifyListeners();
  }
  //#endregion search

  //#region queue
  List<QueueEntry<Track>> _queuedTracks = [];
  List<QueueEntry<Track>> get queuedTracks => _queuedTracks;
  bool _taggingTracks = false;
  bool get taggingTracks => _taggingTracks;

  List<String> _trackTags = [];
  List<String> get trackTags => _trackTags;
  void addTrackTag(String tag) {
    if (!_trackTags.contains(tag)) {
      _trackTags.add(tag);
      notifyListeners();
    }
  }
  void removeTrackTag(String tag) {
    _trackTags.remove(tag);
    notifyListeners();
  }

  int _totalToTag = 1;
  int get totalToTag => _totalToTag;
  int _taggedSoFar = 0;
  int get taggedSoFar => _taggedSoFar;

  bool addTrackToQueue(Track track) {
    bool trackNotInQueue = _queuedTracks.where((element) =>
      element.data.name == track.name).isEmpty;
    if (trackNotInQueue) {
      _queuedTracks.add(QueueEntry<Track>(data: track));
      resetProgress();
      notifyListeners();
      return true;
    }

    return false;
  }

  void removeTrackFromQueue(QueueEntry<Track> track) {
    _queuedTracks.remove(track);
    resetProgress();
    notifyListeners();
  }

  void clearQueue() {
    _queuedTracks = [];
    resetProgress();
    notifyListeners();
  }

  void resetProgress() {
    _totalToTag = 1;
    _taggedSoFar = 0;
    notifyListeners();
  }

  Future<void> removeTagsFromTracks() async {
    if (_trackTags.isEmpty) {
      return;
    }

    _taggingTracks = true;
    notifyListeners();

    _totalToTag = _queuedTracks.length;
    _taggedSoFar = 0;
    log('Beginning to remove tags from $_totalToTag tracks');
    notifyListeners();

    for (var entry in _queuedTracks) {
      for (var tag in _trackTags) {
        String artist = entry.data.artist.text??entry.data.artist.name;
        String name = entry.data.name;
        log('Removing tag "$tag" from "$name" by "$artist"');
        var res = await _api.track.removeTag(
          artist,
          name,
          tag
        );

        if (!res.isSuccess()) {
          log('Error while trying to remove tag on tracks: $res');
          _taggingTracks = false;
          notifyListeners();
          return;
        }

        entry.processed = true;
        _taggedSoFar ++;
        notifyListeners();
      }
    }

    log('Finished removing tags from tracks');
    _taggingTracks = false;
    notifyListeners();
  }

  Future<void> tagTracks() async {
    if (_trackTags.isEmpty) {
      return;
    }

    _taggingTracks = true;
    notifyListeners();

    _totalToTag = _queuedTracks.length;
    _taggedSoFar = 0;
    log('Beginning to tag $_totalToTag tracks');
    notifyListeners();

    String tagsStr = _trackTags.join(',');
    for (var entry in _queuedTracks) {
      if (!_taggingTracks) {
        break;
      }

      String artist = entry.data.artist.text??entry.data.artist.name;
      String name = entry.data.name;
      log('Tagging "$name" by "$artist" with "$tagsStr"');
      var res = await api.track.addTags(
        artist,
        name,
        _trackTags,
      );

      if (!res.isSuccess()) {
        log('Error while trying to tag tracks: $res');
        _taggingTracks = false;
        notifyListeners();
        return;
      }

      entry.processed = true;
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
  Map<TrackCacheKey, TrackCacheEntry> _trackCache = {};
  Map<TrackCacheKey, TrackCacheEntry> get trackCache => _trackCache;

  List<TrackCacheKey> _recentTracks = [];
  List<TrackCacheEntry> get recentTracks =>
    _recentTracks.map((e) => _trackCache[e]).toList();

  Future<List<TrackCacheEntry>> _ensureTracksCached(List<Track> tracks, {
    bool refreshCache=false,
  }) async {
    List<TrackCacheEntry> entries = [];
    for (var track in tracks) {
      var entry = await _ensureCached(new TrackCacheKey(
        name: track.name,
        artist: track.artist.name??track.artist.text,
      ), refreshCache: refreshCache, augmentCache: track);
      if (entry != null) {
        entries.add(entry);
      }
    }

    return entries;
  }

  Future<TrackCacheEntry> _ensureCached(TrackCacheKey key, {
    bool refreshCache=false, Track augmentCache
  }) async {
    if (!refreshCache && _trackCache.containsKey(key)) {
      return _trackCache[key];
    }

    var fetchedEntry = await _fetchTrack(key);
    TrackCacheEntry entryToReturn = fetchedEntry;
    if (entryToReturn != null) {
      if (augmentCache != null) {
        // create a new track combining the fetched and augmented...
        // this is needed because for some tracks, track.getInfo
        // does not return album art... but it does when fetching
        // user.getRecentTracks

        entryToReturn = new TrackCacheEntry(
          tags: fetchedEntry.tags,
          track: entryToReturn.track.copyWith(
            images: augmentCache.images
          ),
        );
      }

      _trackCache[key] = entryToReturn;
    }

    return entryToReturn;
  }

  Future<TrackCacheEntry> _fetchTrack(TrackCacheKey key) async {
    String artist = key.artist;
    String name = key.name;
    var res = await _api.track.getInfo(
      artist: artist,
      track: name,
      userName: _user.name,
    );

    String trackIdentifier = '"$name" by "$artist"';
    log('Fetching info for track $trackIdentifier');
    if (res.hasError()) {
      log('Error when fetching info for track $trackIdentifier: $res');
      return null;
    }

    Track track = res.data.track;

    res = await _api.track.getTags(
      artist: artist,
      track: name,
      user: _user.name,
    );

    log('Fetching tags for track $trackIdentifier');
    if (res.hasError()) {
      log('Error when fetching tags for track $trackIdentifier: $res');
      return null;
    }

    List<String> tags = [];
    if (!(res.data.tags.items == null)) {
      tags = res.data.tags.items.map((x) => x.name).toList();
    }

    return new TrackCacheEntry(
      tags: tags,
      track: track
    );
  }

  Future<void> removeTagFromTrack(TrackCacheEntry entry, String tag) async {

    String artist = entry.track.artist.name??entry.track.artist.text;
    String track = entry.track.name;
    String entryId = '"$track" by "$artist"';
    log('Removing tag "$tag" from $entryId');
    var res = await _api.track.removeTag(
      entry.track.artist.name??entry.track.artist.text,
      entry.track.name,
      tag,
    );
    if (res.hasError()) {
      log('Error when trying to remove tag "$tag" from $entryId');
      return;
    }

    List<String> newTags = []..addAll(entry.tags)..remove(tag);
    var key = TrackCacheKey.fromTrack(entry.track);
    _trackCache.remove(key);
    _trackCache[key] = new TrackCacheEntry(
      tags: newTags,
      track: entry.track,
    );
    log('Removed tag "$tag" from $entryId');
    notifyListeners();
  }


  //#endregion
}