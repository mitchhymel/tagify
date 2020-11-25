
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TagsListItem extends StatelessWidget {

  final String tag;
  final int tagged;
  TagsListItem(this.tag, this.tagged);

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => CustomCard(
      onTap: () => store.selectedTag = tag,
      color: store.selectedTag == tag ? Colors.redAccent : Colors.black12,
      child: Utils.isBigScreen(context) ? Row(
        children: [
          Text(tag),
          Flexible(child: Container()),
          Text(tagged.toString(),
            textAlign: TextAlign.right,
          ),
        ],
      ) : Column(
        children: [
          Text(tag),
          Container(height: 5),
          Text(tagged.toString(),
            textAlign: TextAlign.right,
          ),
        ],
      )
    )
  );
}