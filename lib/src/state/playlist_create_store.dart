import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/models.dart';

class PlaylistCreateStore extends ChangeNotifier {

  bool _mustHaveAllIncludeTags = true;
  bool get mustHaveAllIncludeTags => _mustHaveAllIncludeTags;
  set mustHaveAllIncludeTags(bool other) {
    _mustHaveAllIncludeTags = other;
    notifyListeners();
  }
  Set<String> _includeTags = new Set<String>();
  Set<String> get includeTags => _includeTags;
  Set<String> _excludeTags = new Set<String>();
  Set<String> get excludeTags => _excludeTags;

  String _playlistName = '';
  String get playlistName => _playlistName;
  set playlistName(String other) {
    _playlistName = other;
    notifyListeners();
  }

  bool _creatingPlaylist = false;
  bool get creatingPlaylist => _creatingPlaylist;

  void addIncludeTag(String tag) {
    _includeTags.add(tag);
    notifyListeners();
  }

  void removeIncludeTag(String tag) {
    _includeTags.remove(tag);
    notifyListeners();
  }

  void addExcludeTag(String tag) {
    _excludeTags.add(tag);
    notifyListeners();
  }

  void removeExcludeTag(String tag) {
    _excludeTags.remove(tag);
    notifyListeners();
  }

  List<String> getTracks(Map<String, Set<String>> tagToTracks,
    Map<String, Set<String>> trackToTags,
    Map<String, TrackCacheItem> cache,
  ) {
    Set<String> tracks = new Set<String>();

    _includeTags.forEach((x) {
      if (_mustHaveAllIncludeTags) {
        if (tagToTracks.containsKey(x)) {
          var candidates = tagToTracks[x];
          candidates.forEach((c) {
            if (trackToTags.containsKey(c)) {
              if (trackToTags[c].containsAll(_includeTags)) {
                tracks.add(c);
              }
            }
          });
        }
      }
      else {
        if (tagToTracks.containsKey(x)) {
          tracks.addAll(tagToTracks[x]);
        }
      }
    });

    _excludeTags.forEach((x) {
      if (tagToTracks.containsKey(x)) {
        tracks.removeAll(tagToTracks[x]);
      }
    });

    var list = tracks.toList();
    list.sort((x, y) {
      var a = cache[x];
      var b = cache[y];

      if (a.artist != b.artist) {
        return a.artist.compareTo(b.artist);
      }

      if (a.album != b.album) {
        return a.album.compareTo(b.album);
      }

      return a.trackNumber.compareTo(b.trackNumber);
    });
    return list;
  }


  Future<bool> createPlaylist(String userId, List<String> uris, SpotifyApi authedSpotify) async {
    _creatingPlaylist = true;
    notifyListeners();

    log('Creating playlist with name "$_playlistName"');

    Playlist playlist;
    try {
      playlist = await authedSpotify.playlists.createPlaylist(userId, _playlistName);
    }
    catch (ex) {
      logError('Error when creating playlist: $ex');
      _creatingPlaylist = false;
      notifyListeners();
      return false;
    }

    // spotify only allows adding 100 tracks to a playlist per request
    int increment = 100;
    for (int i = 0; i < uris.length; i+=increment) {
      int maxTracksToAdd = min(increment, uris.length - i);
      List<String> subset = uris.sublist(i, maxTracksToAdd);
      log('Adding ${subset.length} tracks to "$_playlistName"');

      try {
        await authedSpotify.playlists.addTracks(subset, playlist.id);
      }
      catch (ex) {
        logError('Error when adding tracks to playlist: $ex');
        _creatingPlaylist = false;
        notifyListeners();
        return false;
      }
    }

    log('Finished creating playlist "$_playlistName"');
    _creatingPlaylist = false;
    notifyListeners();
    return true;
  }

}