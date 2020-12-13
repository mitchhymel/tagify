
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class SearchTracksControls extends HookWidget {

  @override
  Widget build(BuildContext context) {
    final search = useProvider(searchProvider);
    final spotify = useProvider(spotifyProvider);
    final firebase = useProvider(firebaseProvider);
    final trackController = useTextEditingController(text: search.query);
    return CustomCard(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: trackController,
              onChanged: (x) => search.query = x,
              onSubmitted: (x) => search.search(0, spotify.search, firebase.addAllToCache),
              decoration: InputDecoration(
                hintText: 'Search for tracks to tag by name, artist, or album',
              )
            )
          ),
        ],
      ),
    );
  }
}