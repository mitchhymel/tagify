
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class ArtistCard extends StatelessWidget {

  final bool draggable;
  final Artist artist;
  ArtistCard(this.artist, {this.draggable=true});

  Widget _getCard() => CustomCard(
    constraints: BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: () {},
    child: Row(
      children: [
        if (artist.image.isNotEmpty) Expanded(
          child: Image.network(artist.image[0].text,
            height: 50,
            width: 50,
          )
        ),
        Expanded(child: Text(artist.name)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => (draggable && Utils.isBigScreen(context)) ?
  Draggable(
    data: artist,
    feedback: _getCard(),
    child: _getCard()
  ) : _getCard();
}