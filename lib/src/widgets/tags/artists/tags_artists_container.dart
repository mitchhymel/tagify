
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/tags/artists/tags_artists_list.dart';

class TagsArtistsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
          child: TagsArtistsList()
      ),
    ],
  );
}