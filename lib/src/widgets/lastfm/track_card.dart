
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lastfm/lastfm_api.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/lastfm_store.dart';
import 'package:tagify/src/state/models.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';
import 'package:tagify/src/widgets/common/tag_chip_list.dart';
import 'package:tagify/src/widgets/lastfm/track_favorite_button.dart';

class TrackCard extends StatelessWidget {

  final TrackCacheKey cacheKey;
  final bool draggable;
  TrackCard(this.cacheKey, {
    this.draggable = true,
  });

  final int _imageResolution = 2;

  void _onTap(BuildContext context) {
    bool success = Provider.of<LastFmStore>(context, listen: false)
        .addTrackToQueue(cacheKey);
    if (success && !Platform.isWindows) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blueAccent,
        action: SnackBarAction(
          label: 'dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Text('Added "${cacheKey.toLogStr()}" to track tag queue',
            style: TextStyle(
              color: Colors.white,
            )
        ),
      ));
    }
  }

  Widget _getCard(BuildContext context, TrackCacheEntry entry, {
    bool feedback=false
  }) {

    Track track = entry.track;
    List<String> tags = entry.tags;
    bool hasDataImage = (track.images != null &&
        track.images.isNotEmpty && track.images[_imageResolution].text != null);
    bool hasAlbumImage = (track.album != null &&
        track.album.image != null &&
        track.album.image.isNotEmpty &&
        track.album.image[_imageResolution].text != null);
    bool hasImage = hasDataImage || hasAlbumImage;
    String imageUrl = hasDataImage ? track.images[_imageResolution].text
        : track.album.image[_imageResolution].text;
    String trackArtistName = track.artist.name ?? track.artist.text;

    return CustomCard(
        constraints: !feedback ? null : BoxConstraints(
          maxWidth: 800,
          maxHeight: 300,
        ),
        onTap: !draggable ? (){} : () => _onTap(context),
        color: track.nowPlaying ? Colors.blueGrey : Colors.black12,
        child: IntrinsicHeight(
          child: Stack(
            children: [
              Row(
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
                            onRemoveTag: (t) => store.removeTagFromTrack(cacheKey, t),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                child: TrackFavoriteButton(cacheKey),
                right: 1,
                top: 1,
              )
            ],
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<LastFmStore>(
    builder: (_, store, __) => (draggable && Platform.isWindows) ?
    Draggable(
      data: cacheKey,
      feedback: _getCard(context, store.trackCache[cacheKey], feedback: true),
      child: _getCard(context, store.trackCache[cacheKey])
    ) : _getCard(context, store.trackCache[cacheKey])
  );
}