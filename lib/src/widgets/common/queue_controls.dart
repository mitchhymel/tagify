
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/common/custom_progress_indicator.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';

import 'custom_card.dart';

class QueueControls extends StatefulWidget {
  final Function start;
  final Function stop;
  final Function startRemove;
  final Function stopRemove;
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
    @required this.stop,
    @required this.startRemove,
    @required this.stopRemove,
    this.totalProgress=1,
    this.progressSoFar=0,
  });

  @override
  State createState() => _QueueControlsState();
}

class _QueueControlsState extends State<QueueControls> {

  TextEditingController controller;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = new TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller?.dispose();
    focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: controller,
            focusNode: focusNode,
            onFieldSubmitted: (x) {
              widget.onAddTag(x);
              controller.clearComposing();
              setState((){});
              focusNode.requestFocus();
            },
          )
        ),
        Container(height: 5),
        TagChipList(
          tags: widget.tags,
          onRemoveTag: widget.onRemoveTag,
        ),
        Container(height: 10),
        IntrinsicHeight(
          child: Row(
            children: [
              ElevatedButton(
                child: Icon(Icons.clear_all),
                onPressed: widget.showProgress ? null : widget.clearQueue,
              ),
              Flexible(child: Container()),
              ElevatedButton.icon(
                label: Text('Remove Tags'),
                icon: Icon(widget.showProgress ? Icons.pause : Icons.delete),
                onPressed: widget.tags.isEmpty ? null :
                  widget.showProgress ? widget.stopRemove : widget.startRemove,
              ),
              // ElevatedButton(
              //   child: Icon(widget.showProgress ? Icons.pause : Icons.delete),
              //   onPressed: widget.showProgress ? widget.stop : widget.start,
              // ),
              Flexible(child: Container()),
              ElevatedButton.icon(
                label: Text('Add Tags'),
                icon: Icon(widget.showProgress ? Icons.pause : Icons.add),
                onPressed: widget.tags.isEmpty ? null :
                  widget.showProgress ? widget.stop : widget.start,
              )
            ],
          ),
        ),
        Container(height: 4),
        CustomProgressIndicator(
          totalProgress: widget.totalProgress,
          progressSoFar: widget.progressSoFar,
        )
      ],
    )
  );
}