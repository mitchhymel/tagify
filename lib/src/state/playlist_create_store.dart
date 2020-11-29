
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:spotify/spotify.dart' as spot;
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/models.dart';

class PlaylistCreateStore extends ChangeNotifier {

  bool _mustHaveAllWithTags = true;
  bool get mustHaveAllWithTags => _mustHaveAllWithTags;
  set mustHaveAllWithTags(bool other) {
    _mustHaveAllWithTags = other;
    notifyListeners();
  }
  Set<String> _withTags = new Set<String>();
  Set<String> get withTags => _withTags;
  Set<String> _withoutTags = new Set<String>();
  Set<String> get withoutTags => _withoutTags;

  String _playlistName = '';
  String get playlistName => _playlistName;
  set playlistName(String other) {
    _playlistName = other;
    notifyListeners();
  }

  bool _fetching = false;
  bool get fetching => _fetching;
  set fetching(bool other) {
    _fetching = other;
    notifyListeners();
  }

  Set<TrackCacheKey> _tracks = new Set<TrackCacheKey>();
  Set<TrackCacheKey> get tracks => _tracks;

  void addWithTag(String tag) {
    _withTags.add(tag);
    notifyListeners();
  }

  void removeWithTag(String tag) {
    _withTags.remove(tag);
    notifyListeners();
  }

  void addWithoutTag(String tag) {
    _withoutTags.add(tag);
    notifyListeners();
  }

  void removeWithoutTag(String tag) {
    _withoutTags.remove(tag);
    notifyListeners();
  }

  Future<void> fetchTracksMatchingCriteria({
    @required String lastfmUserName,
    @required LastFmApi lastfm,
    @required spot.SpotifyApi spotify
  }) async {

    if (_withTags.isEmpty) {
      log('At least one tag is needed to create a playlist');
      return;
    }

    _fetching = true;
    notifyListeners();

    // first, fetch from lastfm all tracks for each tag in withTags
    Map<TrackCacheKey, Set<String>> trackToTags = {};
    for (String tag in _withTags) {
      log('Fetching all tracks for tag $tag');
      var newTracks = await _fetchAllTracksForTag(
        tag: tag,
        lastfm: lastfm,
        lastfmUserName: lastfmUserName
      );

      if (newTracks == null) {
        // _fetchAllTracksForTag will log error
        _fetching = false;
        notifyListeners();
        return;
      }

      for (var track in newTracks) {
        var key = TrackCacheKey.fromTrack(track);
        if (!trackToTags.containsKey(key)) {
          trackToTags[key] = new Set<String>();
        }

        trackToTags[key].add(tag.toLowerCase());
      }
    }

    // if using AND, remove tracks that don't have all
    // tags in withTags
    Map<TrackCacheKey, Set<String>> tempCopy = {}..addAll(trackToTags);
    if (_mustHaveAllWithTags) {
      for (var entry in tempCopy.entries) {
        for (var tag in _withTags) {
          if (!entry.value.contains(tag.toLowerCase())) {
            // remove
            log('Removed ${entry.key} since it doesn\'t contain tag $tag');
            trackToTags.remove(entry.key);
          }
        }
      }
    }

    // then remove tracks that also have tags in withoutTags
    Map<String, Set<TrackCacheKey>> tagToTracks = {};
    for (String tag in _withoutTags) {
      log('Fetching all tracks for tag $tag');
      var newTracks = await _fetchAllTracksForTag(
          tag: tag,
          lastfm: lastfm,
          lastfmUserName: lastfmUserName
      );

      if (newTracks == null) {
        // _fetchAllTracksForTag will log error
        _fetching = false;
        notifyListeners();
        return;
      }

      for (var track in newTracks) {
        var key = TrackCacheKey.fromTrack(track);
        if (!tagToTracks.containsKey(tag)) {
          tagToTracks[tag] = new Set<TrackCacheKey>();
        }

        tagToTracks[tag].add(key);

        if (trackToTags.containsKey(key)) {
          log('Removing ${key.name} by ${key.artist} because it is not without tag $tag');
          trackToTags.remove(key);
        }
      }
    }

    _tracks = trackToTags.keys.toSet();
    _fetching = false;
    notifyListeners();

    // finally, fetch all tracks from spotify
  }

  Future<List<Track>> _fetchAllTracksForTag({
    @required String tag,
    @required LastFmApi lastfm,
    @required String lastfmUserName,
  }) async {

    List<Track> res = [];
    int page = 1;
    int limit = 25;
    int total = 0;
    int totalPages = 1;
    bool processedFirst = false;
    while (page <= totalPages) {
      String id = 'tag $tag for page $page with limit $limit';
      log('Getting tracks for $id');
      var resp = await lastfm.user.getPersonalTags(
          lastfmUserName, tag, 'track',
          page: page,
          limit: limit
      );

      if (resp.hasError()) {
        logError('Error when fetching $id: $resp');
        return null;
      }

      page++;
      if (!processedFirst) {
        // first response will tell us how many pages to fetch
        total = resp.data.taggings.attr.total;
        totalPages = resp.data.taggings.attr.totalPages;
        processedFirst = true;
        log('For tag $tag, found $total total tracks, will fetch $totalPages pages');
      }

      var trackTags = resp.data.taggings.tracks.items;
      res.addAll(trackTags);
    }

    return res;
  }

  Future<void> createPlaylist(String userId, spot.SpotifyApi spotify) async {
    _fetching = true;
    notifyListeners();

    List<spot.Track> spotifyTracks = [];
    for (var key in _tracks) {
      String query = '${key.name} ${key.artist}';
      log('Searching spotify for a track matching "$query"');
      var resp = await spotify.search
          .get(query, types: [spot.SearchType.track])
          .first();

      // assume the first hit is the best one
      if (resp.first.items.isNotEmpty) {
        var asTrack = resp.first.items.first as spot.Track;
        log('Assuming best match is "${asTrack.name}" by "${asTrack.artists.first.name}"');
        spotifyTracks.add(asTrack);
      }
      else {
        log('Could not find track matching "$query"');
      }
    }

    log('Creating playlist with name "$_playlistName"');
    var playlist = await spotify.playlists.createPlaylist(userId, _playlistName);

    List<String> uris = spotifyTracks.map((x) => x.uri).toList();

    // spotify only allows adding 100 tracks to a playlist per request
    int increment = 100;
    for (int i = 0; i < uris.length; i+=increment) {
      int maxTracksToAdd = min(increment, uris.length - i);
      List<String> subset = uris.sublist(i, maxTracksToAdd);
      log('Adding ${subset.length} tracks to "$_playlistName"');
      await spotify.playlists.addTracks(subset, playlist.id);
    }

    log('Finished creating playlist "$_playlistName"');
    _fetching = false;
    notifyListeners();
  }


}