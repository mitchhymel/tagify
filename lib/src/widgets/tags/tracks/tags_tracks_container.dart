
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/tags/tracks/tags_tracks_list.dart';

class TagsTracksContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: TagsTracksList()
      ),
    ],
  );
}