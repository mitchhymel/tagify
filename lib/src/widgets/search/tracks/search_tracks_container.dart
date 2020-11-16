
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/search/search_tracks_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/search/tracks/search_tracks_controls.dart';
import 'package:tagify/src/widgets/search/tracks/search_tracks_list.dart';

class SearchTracksContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SearchTracksControls(),
      Consumer<SearchTracksStore>(
        builder: (_, store, __) => CustomLoadingIndicator(store.searching)
      ),
      Expanded(
        child: SearchTracksList()
      ),
    ],
  );
}