import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';

class SessionController {
  BuildContext? context;
  GlobalKey<NavigatorState>? navigatorKey;
  StreamController? streamController;
  static bool startSession = false;

  // Private constructor
  SessionController._private();

  // Singleton instance
  static final SessionController _instance = SessionController._private();

  // Factory method to get the singleton instance
  factory SessionController() => _instance;

  void openSession() {
    if (streamController == null) {
      dev.log("-> Session not initialized");
      return;
    }
    startSession = true;
    Map<String, dynamic> map = {'context': context, 'timer': true};
    streamController!.add(map);
  }

  void closeLocalSession() => startSession = false;

  // By using this function, we will be able to start the session
  void initSession(
      {required StreamController streamController,
      required GlobalKey<NavigatorState> navigatorKey}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      this.streamController = streamController;
      this.navigatorKey = navigatorKey;
      context = navigatorKey.currentContext!;
      dev.log("-> Initialized session");
      Map<String, dynamic> map = {'context': context, 'timer': true};
      streamController.add(map);
    });
  }

  // By using this function, we will be able to stop the session
  void closeSession() {
    if (streamController == null) {
      dev.log("-> Session not initialized");
      return;
    }
    startSession = false;
    Map<String, dynamic> map = {'context': context, 'timer': false};
    streamController!.add(map);
  }
}
