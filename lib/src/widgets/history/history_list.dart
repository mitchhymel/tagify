
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/desktop_listview.dart';
import 'package:tagify/src/widgets/spotify/track_card.dart';

class HistoryList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => HistoryState((history) => DesktopListView(
      itemCount: history.recents.length,
      itemBuilder: (___, index) => TrackCard(
        history.recents[index]
      ),
    )
  );
}
