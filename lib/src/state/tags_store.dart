
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/log_store.dart';

var tags = new TagsStore();

class TagResult {
  final List<Artist> artists;
  final List<Track> tracks;
  final List<Album> albums;

  TagResult({
    @required this.artists,
    @required this.tracks,
    @required this.albums,
  });
}

class TagsStore extends ChangeNotifier {

  String _filter = '';
  String get filter => _filter;
  set filter(String other) {
    _filter = other;
    notifyListeners();
  }

  bool _hasMore = false;
  bool get hasMore => _hasMore;

  bool _fetching = false;
  bool get fetching => _fetching;

  List<Tag> _tags = [];
  List<Tag> get tags => _tags.where((x) => x.name.toLowerCase()
      .contains(_filter.toLowerCase())).toList();

  Map<Tag, TagResult> _cache = {};
  Map<Tag, TagResult> get cache => _cache;

  Tag _selected;
  Tag get selected => _selected;
  set selected(Tag other) {
    _selected = other;
    notifyListeners();

    if (!_cache.containsKey(_selected)) {
      refreshForTag(_selected);
    }
    else {

    }
  }
  TagResult get selectedResult => _cache[_selected];

  Future<void> refresh() async {
    _tags = [];
    notifyListeners();
    await fetch(1);
  }

  Future<void> fetch(int page, {int limit=25}) async {
    _fetching = true;
    notifyListeners();

    log('GetTopTags with results for page $page with limit $limit');

    var response = await lastFm.api.user.getTopTags(lastFm.userSession.userName);

    _fetching = false;
    notifyListeners();

    if (response.error != null) {
      log('Error when fetching tags: $response');
      return;
    }

    List<Tag> tags = response.data.topTags.tags;
    _tags.addAll(tags);
    _hasMore = tags.length == limit;

    log('GetTopTags found ${tags.length} results');
    notifyListeners();
  }

  Future<void> refreshForTag(Tag tag) async {
    _fetching = true;
    notifyListeners();

    var trackResp = await lastFm.api.user.getPersonalTags(
        lastFm.userSession.userName, tag.name, 'track');
    var trackTags = trackResp.data.taggings.tracks.tracks;


    var tagResult = new TagResult(
      artists: [],
      albums: [],
      tracks: trackTags,
    );

    _cache.putIfAbsent(tag, () => tagResult);


    _fetching = false;
    notifyListeners();
  }


}