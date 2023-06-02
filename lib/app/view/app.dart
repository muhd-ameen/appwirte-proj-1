// ignore_for_file: lines_longer_than_80_chars

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/l10n/l10n.dart';
import 'package:todoapp/login/login.dart';
import 'package:todoapp/splash/view/splash_page.dart';
import 'package:todoapp/util/prefs.dart';

Client client = Client();
Prefs prefs = Prefs();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    client
        .setEndpoint('https://192.168.1.24/v1')
        // .setProject('6416d47bba80db47be7f')//1
        .setProject('64172ef86b40fb95bd86') //2

        .setSelfSigned(); // For self signed certificates, only use for development
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashPage(),
    );
  }
}
