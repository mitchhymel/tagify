import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/tags/tags_controls.dart';
import 'package:tagify/src/widgets/tags/tags_list.dart';
import 'package:tagify/src/widgets/tags/tracks/tags_tracks_container.dart';

class TagsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TagsControls(),
      Consumer<LastFmStore>(
        builder: (_, store, __) => CustomLoadingIndicator(store.tagsFetching),
      ),
      Consumer<LastFmStore>(
          builder: (_, store, __) => store.trackToTags.length == 0 && !store.tagsFetching ?
          ElevatedButton(
            child: Text('No tags fetched or found, try refreshing by clicking me'),
            onPressed: () => store.tagsRefresh(),
          ) : Container()
      ),
      Expanded(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  Icon(Icons.tag),
                  Expanded(
                    child: TagsList()
                  )
                ],
              )
            ),
            Flexible(
              flex: 3,
              child: TagsTracksContainer()
            )
          ],
        )
      ),
    ],
  );
}