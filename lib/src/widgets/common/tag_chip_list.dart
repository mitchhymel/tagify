
import 'package:flutter/material.dart';

class TagChipList extends StatelessWidget {

  final Set<String> tags;
  final Function(String) onRemoveTag;
  TagChipList({
    @required this.tags,
    @required this.onRemoveTag,
  });

  @override
  Widget build(BuildContext context) => tags == null || tags.isEmpty ?
    Container() : Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 5,
      children: tags.map((x) => Chip(
        label: Text(x),
        onDeleted: () => onRemoveTag(x),
      )).toList()
  );
}