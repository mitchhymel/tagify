
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/tags/albums/tags_albums_list.dart';

class TagsAlbumsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: TagsAlbumsList()
      ),
    ],
  );
}