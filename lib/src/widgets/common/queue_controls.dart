
import 'package:flutter/material.dart';
import 'package:tagify/src/widgets/common/custom_loading_indicator.dart';

import 'custom_card.dart';

class QueueControls extends StatefulWidget {
  final Function start;
  final Function stop;
  final Function clearQueue;
  final int totalProgress;
  final int progressSoFar;
  final bool showProgress;
  final Function(String) onAddTag;
  final Function onRemoveTag;
  final List<String> tags;
  QueueControls({
    @required this.onAddTag,
    @required this.onRemoveTag,
    @required this.tags,
    @required this.showProgress,
    @required this.clearQueue,
    @required this.start,
    @required this.stop,
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
      children: [
        Expanded(
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
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: widget.tags.map((x) => Chip(
            label: Text(x),
            onDeleted: () => widget.onRemoveTag(x),
          )).toList()
        ),
        Container(height: 10),
        Expanded(
          child: Row(
            children: [
              ElevatedButton(
                child: Icon(Icons.clear_all),
                onPressed: widget.showProgress ? null : widget.clearQueue,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: LinearProgressIndicator(
                    value: widget.progressSoFar / widget.totalProgress,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green)
                  ),
                )
              ),
              ElevatedButton(
                child: Icon(widget.showProgress ? Icons.pause : Icons.play_arrow),
                onPressed: widget.showProgress ? widget.stop : widget.start,
              )
            ],
          ),
        ),
      ],
    )
  );
}