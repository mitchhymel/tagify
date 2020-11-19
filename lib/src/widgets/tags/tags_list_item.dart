
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TagsListItem extends StatelessWidget {

  final Tag tag;
  TagsListItem(this.tag);

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => CustomCard(
      onTap: () => store.tagsSelected = tag.name,
      color: store.tagsSelected == tag.name ? Colors.redAccent : Colors.black12,
      child: Platform.isWindows ? Row(
        children: [
          Text(tag.name),
          Flexible(child: Container()),
          Text(tag.count.toString(),
            textAlign: TextAlign.right,
          ),
        ],
      ) : Column(
        children: [
          Text(tag.name),
          Container(height: 5),
          Text(tag.count.toString(),
            textAlign: TextAlign.right,
          ),
        ],
      )
    )
  );
}