
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/search_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class SearchTracksList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<SearchStore>(
    builder: (_, store, __) => DesktopListView(
      itemCount: store.searchResults.length,
      itemBuilder: (___, index) => TrackCard(store.searchResults[index]),
    )
  );
}