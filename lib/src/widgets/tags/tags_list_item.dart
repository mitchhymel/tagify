
import 'package:flutter/material.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/utils/utils.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class TagsListItem extends StatelessWidget {

  final String tag;
  final int tagged;
  TagsListItem(this.tag, this.tagged);

  @override
  Widget build(BuildContext context) => FirebaseState((store) => CustomCard(
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
  ));
}