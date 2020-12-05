

import 'package:flutter/material.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/models.dart';

typedef FetchSearch = Future<List<TrackCacheItem>> Function(String, int);
typedef EnsureCached = void Function(List<TrackCacheItem>);

class SearchStore extends ChangeNotifier {

  String _query ='';
  String get query => _query;
  set query(String other) {
    _query = other;
    notifyListeners();
  }
  bool _searching = false;
  bool get searching => _searching;
  bool _searchHasMore = false;
  bool get searchHasMore => _searchHasMore;
  List<String> _searchResults = [];
  List<String> get searchResults => _searchResults;

  Future<void> search(int page, FetchSearch searchFunc, EnsureCached cacheFunc) async {
    if (page == 0) {
      _searchResults = [];
    }
    _searching = true;
    notifyListeners();

   try {
     var res = await searchFunc(_query, page);
     cacheFunc(res);
     _searchResults.addAll(res.map((x) => x.id).toList());
   } catch (ex) {
     log('Error while searching: $ex');
   }

    _searching = false;
    notifyListeners();
  }

}