
import 'package:universal_html/html.dart' as html;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Utils {

  static const int IMAGE_QUALITY = 2;

  static const String REDIRECT_URI = kDebugMode ? 'http://localhost:3000'
    : 'https://mitchhymel.github.io/tagify';
  static const String _expectedOrigin = kDebugMode ? 'http://localhost:3000'
    : 'https://mitchhymel.github.io';

  static bool isBigScreenWithoutContext() {
    return kIsWeb || Platform.isWindows;
  }
  static bool isBigScreen(BuildContext context) {
    if (kIsWeb || Platform.isWindows) {
      return MediaQuery.of(context).size.width > 768;
    }

    return false;
  }



  static bool stringIsNotNullOrEmpty(String x) => !(x == null || x == '');

  static String getTokenFromLastFmRedirectUri(String uri) {
    // RegExp exp = new RegExp(r'token=(.*)');
    // var match = exp.firstMatch(uri);
    // print(match.toString());
    // return match.toString();
    var split = uri.split('token=');
    return split[1];
  }

  static bool redirectUriForSpotify(html.MessageEvent event) {
    bool originIsTrusted = (event.origin == Utils._expectedOrigin);
    bool forSpotify = event.data.toString().contains('code');
    return originIsTrusted && forSpotify;
  }

  static void showSnackBar(BuildContext context, String text,{
    bool isError=false,
  }) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: isError ? Colors.redAccent : Colors.blueAccent,
      action: SnackBarAction(
        label: 'dismiss',
        textColor: Colors.white,
        onPressed: () {},
      ),
      content: Text(text,
          style: TextStyle(
            color: Colors.white,
          )
      ),
    ));
  }
}