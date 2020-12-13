import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tagify/src/app/app_state.dart';
import 'package:tagify/src/app/login_screen.dart';
import 'package:tagify/src/app/main_container.dart';

class App extends StatelessWidget {
  final Color accentColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) => ProviderScope(
    child: MaterialApp(
      title: 'Tagify',
      home: Consumer(builder: (_, watch, __) {
       final store = watch(firebaseProvider);
       return store.loggedIn ? MainContainer() : LoginScreen();
      }),
      theme: ThemeData.dark().copyWith(
        accentColor: accentColor,
        indicatorColor: accentColor,
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Colors.white,
          labelColor: accentColor,
        ),
        navigationRailTheme: NavigationRailThemeData(
          selectedIconTheme: IconThemeData(
            color: accentColor,
          ),
          selectedLabelTextStyle: TextStyle(
            color: accentColor
          )
        ),
        toggleableActiveColor: accentColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        )
      ),
    )
  );
}