

import 'package:flutter/cupertino.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/state/log_store.dart';

abstract class BaseLastFmContentStore<T> extends ChangeNotifier {

  String logId();
  bool canFetch();
  Future<LastFmResponse> makeRequest(int page, {int limit=25});
  List<T> convertToResult(LastFmResponse res);

  List<T> _results;
  List<T> get results => _results;

  bool _fetching = false;
  bool get fetching => _fetching;

  bool _hasMore = false;
  bool get hasMore => _hasMore;

  Future<void> refresh() async {
    _results = [];
    notifyListeners();
    await fetch(1);
  }

  Future<void> fetch(int page, {int limit=25}) async {
    if (canFetch()) {
      log('${logId()}: Cannot fetch right now, so will not make a request');
      return;
    }

    _fetching = true;
    notifyListeners();

    //log('Searching for track "$_trackQuery", artist "$_artistQuery", with results for page $page with limit $limit');
    LastFmResponse response = await makeRequest(page, limit:limit);

    _fetching = false;
    notifyListeners();

    if (response.error != null) {
      log('${logId()}: Error when fetching: $response');
      return;
    }

    List<T> newResults = convertToResult(response);
    _results.addAll(newResults);
    _hasMore = _results.length == limit;

    log('${logId()}: Request had ${newResults.length} results');
    notifyListeners();
  }
}