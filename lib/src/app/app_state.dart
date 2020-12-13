import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tagify/src/state/firebase_store.dart';
import 'package:tagify/src/state/history_store.dart';
import 'package:tagify/src/state/log_store.dart';
import 'package:tagify/src/state/playlist_create_store.dart';
import 'package:tagify/src/state/queue_store.dart';
import 'package:tagify/src/state/search_store.dart';
import 'package:tagify/src/state/spotify_store.dart';

final logProvider = ChangeNotifierProvider<LogStore>((_) => logStore);
final spotifyProvider = ChangeNotifierProvider<SpotifyStore>((_) => SpotifyStore());
final firebaseProvider = ChangeNotifierProvider<FirebaseStore>((_) => FirebaseStore());
final searchProvider = ChangeNotifierProvider<SearchStore>((_) => SearchStore());
final historyProvider = ChangeNotifierProvider<HistoryStore>((_) => HistoryStore());
final queueProvider = ChangeNotifierProvider<QueueStore>((_) => QueueStore());
final playlistProvider = ChangeNotifierProvider<PlaylistCreateStore>((_) => PlaylistCreateStore());

typedef StoreWidgetBuilder<T> = Widget Function(T);
class StoreWidget<T extends ChangeNotifier> extends StatelessWidget {
  final ChangeNotifierProvider<T> provider;
  final StoreWidgetBuilder<T> builder;
  StoreWidget({
    @required this.builder,
    @required this.provider
  });

  @override
  Widget build(BuildContext context) => Consumer(builder: (_, watch, __) =>
    builder(watch(provider))
  );
}

class LogState extends StatelessWidget {
  final StoreWidgetBuilder<LogStore> builder;
  LogState(this.builder);

  @override
  Widget build(BuildContext context) => StoreWidget<LogStore>(
    provider: logProvider,
    builder: builder,
  );
}

class SpotifyState extends StatelessWidget {
  final StoreWidgetBuilder<SpotifyStore> builder;
  SpotifyState(this.builder);

  @override
  Widget build(BuildContext context) => StoreWidget<SpotifyStore>(
    provider: spotifyProvider,
    builder: builder,
  );
}

class FirebaseState extends StatelessWidget {
  final StoreWidgetBuilder<FirebaseStore> builder;
  FirebaseState(this.builder);

  @override
  Widget build(BuildContext context) => StoreWidget<FirebaseStore>(
    provider: firebaseProvider,
    builder: builder,
  );
}

class SearchState extends StatelessWidget {
  final StoreWidgetBuilder<SearchStore> builder;
  SearchState(this.builder);

  @override
  Widget build(BuildContext context) => StoreWidget<SearchStore>(
    provider: searchProvider,
    builder: builder,
  );
}

class HistoryState extends StatelessWidget {
  final StoreWidgetBuilder<HistoryStore> builder;
  HistoryState(this.builder);

  @override
  Widget build(BuildContext context) => StoreWidget<HistoryStore>(
    provider: historyProvider,
    builder: builder,
  );
}


class QueueState extends StatelessWidget {
  final StoreWidgetBuilder<QueueStore> builder;
  QueueState(this.builder);

  @override
  Widget build(BuildContext context) => StoreWidget<QueueStore>(
    provider: queueProvider,
    builder: builder,
  );
}


class PlaylistCreateState extends StatelessWidget {
  final StoreWidgetBuilder<PlaylistCreateStore> builder;
  PlaylistCreateState(this.builder);

  @override
  Widget build(BuildContext context) => StoreWidget<PlaylistCreateStore>(
    provider: playlistProvider,
    builder: builder,
  );
}
