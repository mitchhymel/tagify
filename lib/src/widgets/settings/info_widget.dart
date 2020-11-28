

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: () {
      launch('https://github.com/mitchhymel/tagify');
    },
    icon: Icon(AntDesign.github),
  );
}