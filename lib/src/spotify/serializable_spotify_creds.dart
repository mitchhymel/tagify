part of tagify;

extension SerializeableSpotifyApiCredentials on SpotifyApiCredentials {

  static SpotifyApiCredentials fromJson(String json) {
    return fromMap(jsonDecode(json));
  }

  static SpotifyApiCredentials fromMap(Map map) {
    return new SpotifyApiCredentials(
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