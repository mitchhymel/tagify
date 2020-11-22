

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';

class TrackCacheEntry{
  final TrackCacheKey key;
  final String imageUrl;
  final String name;
  final String artist;
  final String album;
  final int playCount;

  TrackCacheEntry({
    this.key,
    this.imageUrl,
    this.name,
    this.artist,
    this.album,
    this.playCount,
  });

  TrackCacheEntry copyWith({
    TrackCacheKey key,
    String imageUrl,
    String name,
    String artist,
    String album,
    int playCount,
  }) => new TrackCacheEntry(
    key: key ?? this.key,
    imageUrl: imageUrl ?? this.imageUrl,
    name: name ?? this.name,
    artist: artist ?? this.artist,
    album: album ?? this.album,
    playCount: playCount ?? this.playCount,
  );
}

class TrackCacheKey {
  final String name;
  final String artist;
  TrackCacheKey({
    @required this.name,
    @required this.artist,
  });

  TrackCacheKey.fromTrack(Track track) :
        name=track.name,
        artist=track.artist.name??track.artist.text;

  Map toMap() => {
    'name': name,
    'artist': artist,
  };
  @override
  String toString() => jsonEncode(toMap());
  Map toJson() => toMap();
  String toLogStr() => '"$name" by "$artist"';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is TrackCacheKey) {
      return name.compareTo(other.name) == 0 &&
          artist.compareTo(other.artist) == 0;
    }

    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => name.hashCode + artist.hashCode;

}