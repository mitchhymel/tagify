

import 'package:flutter/material.dart';
import 'package:tagify/src/state/models.dart';

typedef SearchFunction = Future<List<TrackCacheItem>> Function(String);
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

  Future<void> search(SearchFunction searchFunc, EnsureCached cacheFunc) async {
    _searching = true;
    notifyListeners();

    var res = await searchFunc(_query);
    cacheFunc(res);
    _searchResults.addAll(res.map((x) => x.id).toList());

    _searching = false;
    notifyListeners();
  }

}