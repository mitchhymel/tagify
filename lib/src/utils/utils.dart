
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:tagify/src/state/models.dart';

class Utils {

  static const int IMAGE_QUALITY = 2;

  static bool isBigScreenWithoutContext() {
    return kIsWeb || Platform.isWindows;
  }
  static bool isBigScreen(BuildContext context) {
    if (kIsWeb || Platform.isWindows) {
      return MediaQuery.of(context).size.width > 768;
    }

    return false;
  }

  static String getImageUrl(TrackCacheEntry entry, Track track,{
    int indexOfImagesToUse=IMAGE_QUALITY,
  }) {
    if (entry != null && stringIsNotNullOrEmpty(entry.imageUrl)) {
      return entry.imageUrl;
    }

    bool trackHasImages = track.images != null && track.images.length > 0;
    if (trackHasImages) {
      if (track.images.length >= indexOfImagesToUse+1 &&
          stringIsNotNullOrEmpty(track.images[indexOfImagesToUse].text)) {
        return track.images[indexOfImagesToUse].text;
      }
    }

    bool albumHasImages = track.album != null && track.album.image != null &&
      track.album.image.length > 0;
    if (albumHasImages) {
      if (track.album.image.length >= indexOfImagesToUse+1 &&
          stringIsNotNullOrEmpty(track.album.image[indexOfImagesToUse].text)) {
        return track.album.image[indexOfImagesToUse].text;
      }
    }

    // if we got here... then we didn't find the quality of image we wanted
    // but there might be some lower quality image we can use

    if (trackHasImages) {
      return track.images[track.images.length-1].text;
    }

    if (albumHasImages) {
      return track.album.image[track.album.image.length-1].text;
    }

    // if we got here... then we probably don't have an image and we
    // definitely should
    //throw new Exception('No Image found on entry or track');
    return null;
  }

  static bool stringIsNotNullOrEmpty(String x) => !(x == null || x == '');
}