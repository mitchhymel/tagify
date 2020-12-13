import 'dart:convert';

class SerializableSpotifyCreds {
  final String accessToken;
  final String refreshToken;
  SerializableSpotifyCreds({
    this.accessToken,
    this.refreshToken,
  });

  Map toMap() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };
  static SerializableSpotifyCreds fromMap(Map map) => new SerializableSpotifyCreds(
    accessToken: map['accessToken'],
    refreshToken: map['refreshToken'],
  );
  @override
  String toString() => jsonEncode(toMap());
  static SerializableSpotifyCreds fromString(String json) => fromMap(jsonDecode(json));
}