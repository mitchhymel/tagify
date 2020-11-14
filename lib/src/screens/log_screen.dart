import 'package:tagify/src/widgets/log/log_container.dart';
import 'package:tagify/src/widgets/log/log_controls.dart';
import 'package:flutter/material.dart';

class LogScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Column(
    children: [
      LogControls(),
      Flexible(
        child: LogContainer(),
      )
    ],
  );
}