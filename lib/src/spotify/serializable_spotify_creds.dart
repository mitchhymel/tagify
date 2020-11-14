import 'dart:convert';

import 'package:spotify/spotify.dart' as spot;

extension SerializeableSpotifyApiCredentials on spot.SpotifyApiCredentials {

  static spot.SpotifyApiCredentials fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  static spot.SpotifyApiCredentials fromMap(Map map) {
    return new spot.SpotifyApiCredentials(
      map['clientId'],
      map['clientSecret'],
      accessToken: map['accessToken'],
      expiration: DateTime.parse(map['expiration']),
      refreshToken: map['refreshToken'],
      scopes: map['scopes'].cast<String>(),
    );
  }

  String toJson() {
    return jsonEncode(this.toMap());
  }

  Map toMap() {
    return {
      'clientId': clientId,
      'clientSecret': clientSecret,
      'accessToken': accessToken,
      'expiration': expiration.toString(),
      'refreshToken': refreshToken,
      'scopes': scopes,
    };
  }
}