

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoWidget extends StatelessWidget {

  final bool showText;
  InfoWidget({this.showText=false});

  _onPressed() => launch('https://github.com/mitchhymel/tagify');

  @override
  Widget build(BuildContext context) => showText ? ElevatedButton.icon(
    onPressed: _onPressed,
    icon: Icon(AntDesign.github),
    label: Text('Checkout the source on github!'),
    style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
      backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
    ),
  ) : IconButton(
    onPressed: _onPressed,
    icon: Icon(AntDesign.github),
  );
}