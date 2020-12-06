
import 'dart:collection';

import 'package:flutter/material.dart';

typedef UpdateTagsCallback = Future<bool> Function(bool, Set<String>, Set<String>);

class QueueStore extends ChangeNotifier {

  int get taggedSoFar => _trackQueue.entries.where((x) => x.value).length;
  int get totalToTag => _trackQueue.length;
  bool _tagging = false;
  bool get tagging => _tagging;
  Set<String> _tagsToTagTracksWith = new Set<String>();
  Set<String> get tagsToTagTracksWith => _tagsToTagTracksWith;
  void addTagToTagList(String tag) {
    _tagsToTagTracksWith.add(tag);
    notifyListeners();
  }
  void removeTagFromTagList(String tag) {
    _tagsToTagTracksWith.remove(tag);
    notifyListeners();
  }
  LinkedHashMap<String, bool> _trackQueue = new LinkedHashMap();
  LinkedHashMap<String, bool> get trackQueue => _trackQueue;

  bool addTrackToQueue(String key) {
    _trackQueue[key] = false;
    notifyListeners();
    return true;
  }

  bool addTracksToQueue(List<String> keys) {
    for (var key in keys) {
      addTrackToQueue(key);
    }

    return true;
  }

  void removeTrackFromQueue(String key) {
    _trackQueue.remove(key);
    notifyListeners();
  }

  void clearQueue() {
    _trackQueue = new LinkedHashMap();
    notifyListeners();
  }

  Future<bool> startTagging(bool add, UpdateTagsCallback updateTags) async {
    _tagging = true;
    notifyListeners();

    // updateTags will log error if there was any
    var success = await updateTags(add, _trackQueue.keys.toSet(),
        _tagsToTagTracksWith);

    _trackQueue.entries.forEach((x) => _trackQueue[x.key] = true);

    _tagging = false;
    notifyListeners();
    return success;
  }


}