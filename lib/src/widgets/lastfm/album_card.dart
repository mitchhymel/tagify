
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class AlbumCard extends StatelessWidget {

  final bool draggable;
  final Album album;
  AlbumCard(this.album, {this.draggable=true});

  Widget _getCard() => CustomCard(
    constraints: BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: () {},
    child: Row(
      children: [
        if (album.image.isNotEmpty) Expanded(
          child: Image.network(album.image[0].text,
            height: 50,
            width: 50,
          )
        ),
        Expanded(child: Text(album.name)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => (draggable && Platform.isWindows) ?
  Draggable(
    data: album,
    feedback: _getCard(),
    child: _getCard()
  ) : _getCard();
}