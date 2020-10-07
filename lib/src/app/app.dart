part of tagify;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<AppStore>(create: (_) => AppStore()),
      ChangeNotifierProvider<SpotifyStore>(create: (_) => SpotifyStore()),
    ],
    child: MaterialApp(
      title: 'Tagify',
      home: AppWidget(),
      theme: ThemeData.dark(),
    )
  );
}