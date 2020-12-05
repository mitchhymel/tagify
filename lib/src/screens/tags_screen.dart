import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';
import 'package:tagify/src/widgets/tags/tags_controls.dart';
import 'package:tagify/src/widgets/tags/tags_list.dart';
import 'package:tagify/src/widgets/tags/tracks/tags_tracks_container.dart';

class TagsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      if (!Utils.isBigScreen(context)) Column(
        children: [
          TagsControls(),
          Consumer<FirebaseStore>(
            builder: (_, store, __) => CustomLoadingIndicator(store.fetching),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: 90,
            ),
            child: TagsList(scrollDirection: Axis.horizontal),
          ),
          Expanded(
            child: TagsTracksContainer()
          )
        ],
      ),
      if (Utils.isBigScreen(context))Row(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                TagsControls(),
                Icon(Icons.tag),
                Expanded(
                  child: TagsList()
                )
              ],
            )
          ),
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Consumer<FirebaseStore>(
                  builder: (_, store, __) => CustomLoadingIndicator(store.fetching),
                ),
                Expanded(
                  child: TagsTracksContainer()
                )
              ]
            )
          )
        ],
      ),
      Positioned(
        right: 10,
        bottom: 10,
        child: Consumer<FirebaseStore>(
          builder: (_, store, __) => FloatingActionButton(
            onPressed: store.getTags,
            child: Icon(Icons.refresh),
          )
        )
      ),
    ],
  );
}