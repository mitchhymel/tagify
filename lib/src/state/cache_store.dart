
import 'package:flutter/material.dart';
import 'package:tagify/src/state/models.dart';

class CacheStore extends ChangeNotifier {

  Map<String, TrackCacheItem> _trackCache = {};
  Map<String, TrackCacheItem> get trackCache => _trackCache;

  void addToCache(TrackCacheItem item) {
    _trackCache[item.id] = item;
    notifyListeners();
  }

  void addAllToCache(List<TrackCacheItem> items) {
    items.forEach((x) => addToCache(x));
  }
}