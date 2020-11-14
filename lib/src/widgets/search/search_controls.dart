import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tagify/src/state/search_store.dart';

import '../common/custom_card.dart';

typedef OnSearchTrack = Function(String, String);
typedef OnSearchArtist = Function(String);
typedef OnSearchAlbum = Function(String);

class SearchControls extends StatefulWidget {

  final OnSearchTrack onSearchTrack;
  final OnSearchArtist onSearchArtist;
  final OnSearchAlbum onSearchAlbum;
  SearchControls({
    @required this.onSearchTrack,
    @required this.onSearchArtist,
    @required this.onSearchAlbum,
  });


  @override
  State createState() => new SearchControlsState();
}

class SearchControlsState extends State<SearchControls> {

  Timer _debounce;
  TextEditingController _albumController;
  TextEditingController _artistController;
  TextEditingController _trackController;
  SearchState _search = SearchState.Track;

  @override
  void initState() {
    super.initState();
    _albumController = new TextEditingController();
    _artistController = new TextEditingController();
    _trackController = new TextEditingController();
  }

  @override
  void dispose() {
    _albumController.dispose();
    _artistController.dispose();
    _trackController.dispose();
    super.dispose();
  }

  Widget _getListTile(text, SearchState val) => Expanded(
    child: ListTile(
      title: Text(text),
      leading: Radio(
        value: val,
        groupValue: _search,
        onChanged: (SearchState x) => setState((){_search = x;})
      )
    )
  );

  Widget _getTextEditWidget(controller, hint, onChanged) => Expanded(
    child: Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
        ),
        onChanged: (x) {
          if (_debounce?.isActive ?? false) _debounce.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            onChanged(x);
          });
        },
      )
    )
  );

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              _getListTile('Track', SearchState.Track),
              _getListTile('Artist', SearchState.Artist),
              _getListTile('Album', SearchState.Album),
            ],
          ),
          Row(
            children: [
              if(_search == SearchState.Track) _getTextEditWidget(
                _trackController,
                'Search by track name',
                (x) => widget.onSearchTrack(x, _artistController.text),
              ),
              if(_search == SearchState.Track) _getTextEditWidget(
                _artistController,
                'Optionally, include artist name',
                (x) => widget.onSearchTrack(x, _artistController.text)
              ),
              if (_search == SearchState.Album) _getTextEditWidget(
                _albumController,
                'Search by album name',
                (x) => widget.onSearchAlbum(x),
              ),
              if (_search == SearchState.Artist) _getTextEditWidget(
                _artistController,
                'Search by artist name',
                (x) => widget.onSearchArtist(x),
              ),
            ],
          ),
        ],
      )
    )
  );
}