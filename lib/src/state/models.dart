

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';

class TagResult {
  final List<Artist> artists;
  final List<TrackCacheKey> tracks;
  final List<Album> albums;

  TagResult({
    @required this.artists,
    @required this.tracks,
    @required this.albums,
  });
}

class TrackCacheEntry{
  List<String> tags;
  Track track;
  TrackCacheEntry({
    this.tags,
    this.track
  });

  TrackCacheKey get key => TrackCacheKey.fromTrack(track);
  String get name => track.name;
  String get artist => track.artist.name??track.artist.text;
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
  int get hashCode => super.hashCode;

}

class QueueEntry<T> {

  final T data;
  bool processed;
  QueueEntry({
    this.data,
    this.processed=false,
  });

  @override
  String toString() => jsonEncode(toMap());
  Map toMap() => {
    'data': data,
    'processed': processed,
  };
}