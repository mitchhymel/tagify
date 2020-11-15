
import 'package:flutter/material.dart';
import 'package:lastfm/src/lastfm_response.dart';
import 'package:tagify/src/state/lastfm_store.dart';

class TagsTracksStore extends ChangeNotifier {

  String _filter = '';
  String get filter => _filter;
  set filter(String other) {
    _filter = other;
    notifyListeners();
  }


}