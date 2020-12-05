
import 'package:flutter/material.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/state/search_store.dart';

typedef FetchHistory = Future<List<TrackCacheItem>> Function(int);

class HistoryStore extends ChangeNotifier {

  List<String> _recents = [];
  List<String> get recents => _recents;
  bool _recentsHasMore = false;
  bool get recentsHasMore => _recentsHasMore;
  bool _recentsFetching = false;
  bool get recentsFetching => _recentsFetching;
  String _nowPlaying;
  String get nowPlaying => _nowPlaying;

  Future<void> fetch(int page,
    FetchHistory getHistory, EnsureCached cache
  ) async {
    if (page == 0) {
      _recents = [];
    }
    _recentsFetching = true;
    notifyListeners();

    try {
      var res = await getHistory(page);
      cache(res);
      _recents.addAll(res.map((x) => x.id).toList());
    } catch (ex) {
      log('Error while getting history: $ex');
    }

    _recentsFetching = false;
    notifyListeners();
  }

}