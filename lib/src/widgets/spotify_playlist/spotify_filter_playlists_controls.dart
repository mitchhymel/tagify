

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class SpotifyFilterPlaylistsControls extends HookWidget {

  @override
  Widget build(BuildContext context) {
    var spotify = useProvider(spotifyProvider);
    var controller = useTextEditingController(text: spotify.filter);
    var focus = useFocusNode();
    return CustomCard(
      child: TextField(
        onChanged: (x) => spotify.filter = x,
        focusNode: focus,
        decoration: InputDecoration(
          hintText: 'Filter playlists',
          suffixIcon: spotify.filter.isNotEmpty ? IconButton(
            iconSize: 20,
            icon: Icon(Icons.clear),
            color: Colors.white,
            onPressed: () {
              spotify.filter = '';
              SchedulerBinding.instance.addPostFrameCallback((_) {
                focus.unfocus();
                controller.clear();
              });
            },
          ) : null,
        ),
      )
    );
  }
}