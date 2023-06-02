// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:todoapp/helper/auth_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final authHelper = AuthHelper();
              authHelper.signOut(context: context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
        title: const Text('Home'),
      ),
      body: const Center(
        child: Placeholder(),
      ),
    );
  }
}
