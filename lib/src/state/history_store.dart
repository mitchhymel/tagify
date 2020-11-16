
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/log_store.dart';

var history = new HistoryStore();

class HistoryStore extends ChangeNotifier {
  List<Track> _recents = [];
  List<Track> get recents => _recents;


  Track _nowPlaying;
  Track get nowPlaying => _nowPlaying;

  bool _hasMore = false;
  bool get hasMore => _hasMore;

  bool _fetching = false;
  bool get fetching => _fetching;

  Future<void> refresh() async {
    _recents = [];
    notifyListeners();

    await fetchAndAddToRecents(1, 25);
  }

  Future<void> fetchAndAddToRecents(int page, int pageLimit) async {
    if (_fetching) {
      log('Already fetching requests... returning early');
      return;
    }

    log('Fetching recents for page $page with a limit of $pageLimit');

    var newRecents = await _fetchRecents(page, pageLimit);

    // adds currently playing track as 1 more than the limit we request
    _hasMore = newRecents.length == pageLimit + 1;

    // the currently playing track will always be the first
    if (newRecents.first.nowPlaying) {
      _nowPlaying = newRecents.first;
      newRecents.removeAt(0);
    }
    _recents.addAll(newRecents);
    notifyListeners();
  }

  Future<List<Track>> _fetchRecents(int page, int pageLimit) async {
    _fetching = true;
    notifyListeners();

    if (!lastFm.loggedIn) {
      log('Unable to fetch recents due to not being logged in to lastFm');
      return [];
    }

    var res = await lastFm.api.user.getRecentTracks(lastFm.userSession.userName,
      page: page,
      limit: pageLimit,
    );

    _fetching = false;
    notifyListeners();

    if (!res.isSuccess()) {
      log('Error when fetching recents: $res');
      return [];
    }

    var tracks = res.data.recentTracks.tracks;

    return tracks;
  }
}