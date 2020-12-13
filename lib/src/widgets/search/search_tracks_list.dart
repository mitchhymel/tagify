
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class SearchTracksList extends HookWidget {

  @override
  Widget build(BuildContext context) {
    final search = useProvider(searchProvider);
    final results = search.searchResults;
    return DesktopListView(
      itemCount: results.length,
      itemBuilder: (___, index) => TrackCard(results[index]),
    );
  }
}