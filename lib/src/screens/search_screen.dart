import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/search_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/search/search_tracks_controls.dart';
import 'package:tagify/src/widgets/search/search_tracks_list.dart';

class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SearchTracksControls(),
      Consumer<SearchStore>(
        builder: (_, store, __) => CustomLoadingIndicator(store.searching)
      ),
      Expanded(
        child: SearchTracksList()
      ),
    ],
  );
}