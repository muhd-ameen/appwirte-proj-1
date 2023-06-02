// ignore_for_file: inference_failure_on_instance_creation, use_build_context_synchronously, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:todoapp/app/view/app.dart';
import 'package:todoapp/home/view/home_page.dart';
import 'package:todoapp/login/login.dart';
import 'package:todoapp/util/prefs.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    getSessionDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'TODO APP',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Future<void> getSessionDetails() async {
    Future.delayed(const Duration(seconds: 2), () async {
      await prefs.init();
      final sessionId = Prefs.getSessionId();
      if (sessionId.isEmpty) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    });
  }
}
