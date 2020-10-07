part of tagify;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider<AppStore>(create: (_) => AppStore()),
      ChangeNotifierProvider<AuthStore>(create: (_) => AuthStore()),
    ],
    child: MaterialApp(
      title: 'Tagify',
      home: AppWidget(),
    )
  );
}