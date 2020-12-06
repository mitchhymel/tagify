
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/common/custom_progress_indicator.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';

import 'custom_card.dart';


class QueueControls extends StatelessWidget {
  final Function start;
  final Function startRemove;
  final Function clearQueue;
  final int totalProgress;
  final int progressSoFar;
  final bool showProgress;
  final Function(String) onAddTag;
  final Function onRemoveTag;
  final Set<String> tags;
  QueueControls({
    @required this.onAddTag,
    @required this.onRemoveTag,
    @required this.tags,
    @required this.showProgress,
    @required this.clearQueue,
    @required this.start,
    @required this.startRemove,
    this.totalProgress=1,
    this.progressSoFar=0,
  });

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TagChipList(
            tags: tags,
            onRemoveTag: onRemoveTag,
            onAddTag: onAddTag,
          ),
        ),
        Container(height: 10),
        IntrinsicHeight(
          child: Row(
            children: [
              ElevatedButton(
                child: Icon(Icons.clear_all),
                onPressed: showProgress ? null : clearQueue,
              ),
              Flexible(child: Container()),
              ElevatedButton.icon(
                label: Text('Remove Tags'),
                icon: Icon(showProgress ? Icons.pause : Icons.delete),
                onPressed: tags.isEmpty ? null :
                  showProgress ? null : startRemove,
              ),
              Flexible(child: Container()),
              ElevatedButton.icon(
                label: Text('Add Tags'),
                icon: Icon(showProgress ? Icons.pause : Icons.add),
                onPressed: tags.isEmpty ? null :
                  showProgress ? null : start,
              )
            ],
          ),
        ),
        Container(height: 4),
        CustomProgressIndicator(
          spin: showProgress,
          totalProgress: totalProgress,
          progressSoFar: progressSoFar,
        ),
      ],
    )
  );
}