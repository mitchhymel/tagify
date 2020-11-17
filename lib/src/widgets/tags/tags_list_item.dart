
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
      onTap: () => store.tagsSelected = tag,
      color: store.tagsSelected == tag ? Colors.redAccent : Colors.black12,
      child: Row(
        children: [
          Text(tag.name),
          Flexible(child: Container()),
          Text(tag.count.toString(),
            textAlign: TextAlign.right,
          ),
        ],
      )
    )
  );
}