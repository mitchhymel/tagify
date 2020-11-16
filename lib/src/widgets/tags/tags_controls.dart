
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/tags_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/custom_text_field.dart';

class TagsControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<TagsStore>(
    builder: (_, store, __) => CustomCard(
      child: CustomTextField(
        initialText: store.filter,
        hint: 'Filter tags',
        onChanged: (x) => store.filter = x,
        onSubmitted: (x) => store.filter = x,
      )
    )
  );
}