
import 'package:flutter/cupertino.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/log_store.dart';

class SearchTracksStore extends ChangeNotifier {

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

  List<Track> _tracks = [];
  List<Track> get tracks => _tracks;

  bool _searching = false;
  bool get searching => _searching;

  bool _hasMore = false;
  bool get hasMore => _hasMore;

  Future<void> refresh() async {
    _tracks = [];
    notifyListeners();
    await search(1);
  }

  Future<void> search(int page, {int limit=25}) async {
    if (_trackQuery.isEmpty) {
      log('Search track query is empty, so will not make a request');
      return;
    }

    _searching = true;
    notifyListeners();

    log('Searching for track "$_trackQuery", artist "$_artistQuery", with results for page $page with limit $limit');
    LastFmResponse response;
    if (_artistQuery.isEmpty) {
      response = await lastFm.api.track.search(_trackQuery,
        page: page,
        limit: limit
      );
    }
    else {
      response = await lastFm.api.track.search(_trackQuery,
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

    List<Track> tracks = response.data.results.tracks.tracks;
    _tracks.addAll(tracks);
    _hasMore = tracks.length == limit;

    log('Search found ${tracks.length} results');
    notifyListeners();
  }
}