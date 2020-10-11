library tagify;

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:provider/provider.dart';
import 'package:oauth2/oauth2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lastfm/lastfm_api.dart';

part 'package:tagify/src/app/app.dart';
part 'package:tagify/src/app/app_widget.dart';

part 'package:tagify/src/screens/main_container.dart';
part 'package:tagify/src/screens/settings_screen.dart';
part 'package:tagify/src/screens/spotify_playlist_screen.dart';
part 'package:tagify/src/screens/last_fm_screen.dart';


part 'package:tagify/src/lastfm/secrets.dart';

part 'package:tagify/src/spotify/secrets.dart';
part 'package:tagify/src/spotify/serializable_spotify_creds.dart';

part 'package:tagify/src/widgets/lastfm/lastfm_account_widget.dart';

part 'package:tagify/src/widgets/spotify/spotify_playlist_list.dart';
part 'package:tagify/src/widgets/spotify/spotify_playlist_list_item.dart';
part 'package:tagify/src/widgets/spotify/spotify_account_widget.dart';

part 'package:tagify/src/state/app_store.dart';
part 'package:tagify/src/state/spotify_store.dart';
part 'package:tagify/src/state/lastfm_store.dart';