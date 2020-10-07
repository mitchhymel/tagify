library tagify;

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:provider/provider.dart';
import 'package:oauth2/oauth2.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'package:tagify/src/app/app.dart';
part 'package:tagify/src/app/app_widget.dart';

part 'package:tagify/src/screens/main_screen.dart';

part 'package:tagify/src/spotify/secrets.dart';
part 'package:tagify/src/spotify/serializable_spotify_creds.dart';

part 'package:tagify/src/state/app_store.dart';
part 'package:tagify/src/state/auth_store.dart';