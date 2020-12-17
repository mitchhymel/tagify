
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as spot;

class TrackCacheItem {
  final String id;
  final String name;
  final String artist;
  final String album;
  final String imageUrl;
  final String uri;
  final int trackNumber;

  TrackCacheItem({
    this.id,
    this.name,
    this.artist,
    this.album,
    this.imageUrl,
    this.uri,
    this.trackNumber,
  });

  bool get onSpotify => !id.contains(name);

  // assuming that no artist, track or album will have these characters...
  static const String _delimiter = '##__##';

  // if spotify id is null, then that means that this track was in a playlist,
  // but is no longer on spotify... in which case we'll just use
  // the name_artist_album as the id
  TrackCacheItem.fromSpotifyTrack(spot.Track track):
    id=track.id??'${track.name}$_delimiter${track.artists.first.name}$_delimiter${track.album.name}',
    name=track.name,
    artist=track.artists.first.name,
    album=track.album.name,
    imageUrl=track.album.images.length > 0 ? track.album.images[1].url : null,
    uri=track.uri,
    trackNumber=track.trackNumber;

  static TrackCacheItem fromNonSpotifyId(String id) {
    if (idIsOnSpotify(id)) {
      throw new Exception('This track id is on spotify, why are you here?');
    }

    List<String> parts = id.split(_delimiter).toList();
    return new TrackCacheItem(
      id: id,
      trackNumber: 0,
      name: parts[0],
      artist: parts[1],
      album: parts[2],
      imageUrl: null,
      uri: null,
    );
  }

  static bool idIsOnSpotify(String id) {
    return !id.contains(_delimiter);
  }

  TrackCacheItem copyWith({
    String id,
    String name,
    String artist,
    String album,
    String imageUrl,
    String externalUrl,
    int trackNumber,
  }) => new TrackCacheItem(
    id: id ?? this.id,
    name: name ?? this.name,
    artist: artist ?? this.artist,
    album: album ?? this.album,
    imageUrl: imageUrl ?? this.imageUrl,
    uri: externalUrl ?? this.uri,
    trackNumber: trackNumber ?? this.trackNumber,
  );


  @override
  String toString() => jsonEncode(toMap());
  Map toMap() => {
    'id': id,
    'name': name,
    'artist': artist,
    'album': album,
    'imageUrl': imageUrl,
    'externalUrl': uri,
    'trackNumber': trackNumber,
  };
}
