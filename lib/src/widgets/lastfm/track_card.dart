
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';

class TrackCard extends StatelessWidget {

  final bool draggable;
  final TrackCacheEntry entry;
  TrackCard(this.entry, {
    this.draggable = true,
  });

  final int _imageResolution = 2;

  Track get track => entry.track;
  List<String> get tags => entry.tags;
  String get imageUrl => hasDataImage ? track.images[_imageResolution].text
      : track.album.image[_imageResolution].text;
  bool get hasDataImage => (track.images != null &&
      track.images.isNotEmpty && track.images[_imageResolution].text != null);
  bool get hasAlbumImage => (track.album != null &&
      track.album.image != null &&
      track.album.image.isNotEmpty &&
      track.album.image[_imageResolution].text != null);
  bool get hasImage => hasDataImage || hasAlbumImage;
  String get trackArtistName => track.artist.name ?? track.artist.text;

  Widget _getCard(BuildContext context, {bool feedback=false}) => CustomCard(
    constraints: !feedback ? null : BoxConstraints(
      maxWidth: 800,
      maxHeight: 300,
    ),
    onTap: !draggable ? (){} : () {
      bool success = Provider.of<LastFmStore>(context, listen: false)
          .addTrackToQueue(track);
      if (success && !Platform.isWindows) {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blueAccent,
          action: SnackBarAction(
            label: 'dismiss',
            textColor: Colors.white,
            onPressed: () {},
          ),
          content: Text('Added "${track.name}" by "$trackArtistName" to track tag queue',
            style: TextStyle(
              color: Colors.white,
            )
          ),
        ));
      }
    },
    color: track.nowPlaying ? Colors.blueGrey : Colors.black12,
    child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (hasImage) Image.network(imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.fill,
          ),
          if (hasImage) Container(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(track.name,
                  style: TextStyle(
                    fontSize: 20,
                  )
                )),
                Container(height: 10),
                Expanded(child: Text(trackArtistName)),
              ],
            )
          ),
          Expanded(
            child:  Wrap(
              children: [
                Consumer<LastFmStore>(
                  builder: (_, store, __) => TagChipList(
                    tags: tags,
                    onRemoveTag: (t) => store.removeTagFromTrack(entry, t),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    )
  );

  @override
  Widget build(BuildContext context) => (draggable && Platform.isWindows) ?
  Draggable(
    data: track,
    feedback: _getCard(context, feedback: true),
    child: _getCard(context)
  ) : _getCard(context);
}