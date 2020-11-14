
import 'package:flutter/cupertino.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/state/lastfm_store.dart';

enum SearchState {
  Track,
  Artist,
  Album,
}

class SearchStore extends ChangeNotifier {


  SearchState _searchState = SearchState.Track;
  SearchState get searchState => _searchState;
  String _query ='';
  String get query => _query;
  String _additionalQuery = '';
  String get additionalQuery => _additionalQuery;


  List<TrackSearchResult> _tracks = [];
  List<TrackSearchResult> get tracks => _tracks;


  bool _searching = false;
  bool get searching => _searching;

  search() async {
    if (_query == '') {
      return;
    }

    switch (_searchState) {
      case SearchState.Album:
        _searchAlbums(_query);
        break;
      case SearchState.Artist:
        _searchAlbums(_query);
        break;
      case SearchState.Track:
        _searchTracks(_query, _additionalQuery);
        break;
      default:
        throw new Exception('Unexpected search state');
    }
  }

  _searchTracks(String track, String artist) async {
    _tracks = [];
    notifyListeners();

    var response = await lastFm.api.track.search(track,
      artist: artist,
    );

    if (response.error != null) {
      print(response.error);
      return;
    }

    List<TrackSearchResult> tracks = TrackSearchResult.fromLastFmResponse(
        response);
    _tracks = tracks;
    notifyListeners();
  }

  _searchAlbums(String album) async {

  }

  _searchArtists(String artist) async {

  }
}