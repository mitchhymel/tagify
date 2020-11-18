

import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {

  final bool showText;
  final int progressSoFar;
  final int totalProgress;

  CustomProgressIndicator({
    this.showText=true,
    @required this.progressSoFar,
    @required this.totalProgress,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('Progress: $progressSoFar / $totalProgress'),
      Container(height: 4),
      IntrinsicHeight(
        child: LinearProgressIndicator(
          minHeight: 8,
          value: totalProgress == 0 ? 0 : progressSoFar / totalProgress,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green)
        ),
      ),
    ]
  );
}