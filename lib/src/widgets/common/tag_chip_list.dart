
import 'package:flutter/material.dart';

import 'add_tag_chip.dart';

class TagChipList extends StatelessWidget {

  final Set<String> tags;
  final Function(String) onRemoveTag;
  final Function(String) onAddTag;
  TagChipList({
    @required this.tags,
    @required this.onRemoveTag,
    this.onAddTag,
  });

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: 5,
    children: [
      if (tags != null) ...tags.map((x) => Chip(
        label: Text(x),
        onDeleted: () => onRemoveTag(x),
      )).toList(),
      if (onAddTag != null) AddTagChip(
        onSubmit: onAddTag,
      )
    ]
  );
}