
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {

  final bool showProgress;
  CustomLoadingIndicator(this.showProgress);

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.all(4),
    child: showProgress ? Center(child: LinearProgressIndicator())
        : Container(height: 4),
  );
}