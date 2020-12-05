
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/history_store.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class HistoryList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Consumer<HistoryStore>(
    builder: (_, history, __) => DesktopListView(
      itemCount: history.recents.length,
      itemBuilder: (___, index) => TrackCard(
        history.recents[index]
      ),
    )
  );
}
