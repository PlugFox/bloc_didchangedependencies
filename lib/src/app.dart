import 'package:bloc_sample/src/authentication.dart';
import 'package:bloc_sample/src/home.dart';
import 'package:bloc_sample/src/splash.dart';
import 'package:flutter/material.dart';

@immutable
class App extends StatelessWidget {
  static const String title = 'Bloc Sample';

  const App({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
    title: title,
    home: Splash(
      child: Authentication(
        child: Home(),
      ),
    ),
  );
}