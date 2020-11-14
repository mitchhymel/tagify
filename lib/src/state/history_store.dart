
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/state/lastfm_store.dart';

var history = new HistoryStore();

class HistoryStore extends ChangeNotifier {
  List<RecentTracksResult> _recents = [];
  List<RecentTracksResult> get recents => _recents;
  bool fetchingRecents = false;

  RecentTracksResult _nowPlaying;
  RecentTracksResult get nowPlaying => _nowPlaying;

  Future<void> refreshRecents() async {
    _recents = [];
    notifyListeners();

    await fetchAndAddToRecents(1, 25);
  }

  Future<void> fetchAndAddToRecents(int page, int pageLimit) async {
    if (fetchingRecents) {
      print('already fetchingrecents, returning early');
      return;
    }

    print('$page, $pageLimit');
    var newRecents = await _fetchRecents(page, pageLimit);

    // the currently playing track will always be the first
    if (newRecents.first.attr.nowplaying) {
      _nowPlaying = newRecents.first;
      newRecents.removeAt(0);
    }
    _recents.addAll(newRecents);
    print(_recents.length);
    notifyListeners();
  }

  Future<List<RecentTracksResult>> _fetchRecents(int page, int pageLimit) async {
    if (fetchingRecents) {
      print('already fetchingrecents, returning early');
      return [];
    }

    fetchingRecents = true;

    if (!lastFm.loggedIn) {
      print('not logged in');
      return [];
    }

    var res = await lastFm.api.user.getRecentTracks(lastFm.userSession.userName,
      page: page,
      limit: pageLimit,
    );
    if (!res.isSuccess()) {
      print(res);
      print('error on fetching recenttracks');
      return [];
    }

    var tracks = RecentTracksResult.fromLastFmResponse(res);

    fetchingRecents = false;

    return tracks;
  }
}