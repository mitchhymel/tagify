

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:tagify/src/state/spotify_store.dart';
import 'package:tagify/src/widgets/common/custom_card.dart';

class SpotifyFilterPlaylistsControls extends HookWidget {

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<SpotifyStore>(context);
    var controller = useTextEditingController(text: store.filter);
    var focus = useFocusNode();
    return CustomCard(
      child: TextField(
        onChanged: (x) => store.filter = x,
        focusNode: focus,
        decoration: InputDecoration(
          hintText: 'Filter playlists',
          suffixIcon: store.filter.isNotEmpty ? IconButton(
            iconSize: 20,
            icon: Icon(Icons.clear),
            color: Colors.white,
            onPressed: () {
              store.filter = '';
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