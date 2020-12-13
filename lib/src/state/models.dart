
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as spot;

class TrackCacheItem {
  final String id;
  final String name;
  final String artist;
  final String album;
  final String imageUrl;
  final String externalUrl;
  final int trackNumber;

  TrackCacheItem({
    this.id,
    this.name,
    this.artist,
    this.album,
    this.imageUrl,
    this.externalUrl,
    this.trackNumber,
  });

  TrackCacheItem.fromSpotifyTrack(spot.Track track):
    id=track.id,
    name=track.name,
    artist=track.artists.first.name,
    album=track.album.name,
    imageUrl=track.album.images[1].url,
    externalUrl=track.uri,
    trackNumber=track.trackNumber;

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
    externalUrl: externalUrl ?? this.externalUrl,
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
    'externalUrl': externalUrl,
    'trackNumber': trackNumber,
  };
}
