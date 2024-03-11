import 'dart:async';

import 'package:flutter/material.dart';

import 'first_page.dart';
import 'session-manager/session.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final streamController = StreamController();

  @override
  Widget build(BuildContext context) {
    return SessionWidget(
      navigatorKey: navigatorKey,
      duration: const Duration(seconds: 5),
      streamController: streamController,
      onSessionTimeout: (context) {
        _showTimeoutDialog(context);
      },
      child: MaterialApp(
        title: 'Session Timeout',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const FirstPage(),
      ),
    );
  }

  _showTimeoutDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          // ignore: deprecated_member_use
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: const Text("session timeout"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text("okay"))
              ],
            ),
          );
        });
  }
}
