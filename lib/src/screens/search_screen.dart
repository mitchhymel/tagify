import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/search/search_tracks_controls.dart';
import 'package:tagify/src/widgets/search/search_tracks_list.dart';

class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SearchTracksControls(),
      Consumer(builder: (_, watch, __) =>
        CustomLoadingIndicator(watch(searchProvider).searching)
      ),
      Expanded(
        child: SearchTracksList()
      ),
    ],
  );
}