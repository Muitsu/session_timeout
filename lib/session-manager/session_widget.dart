import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:local_session/session-manager/session.dart';

class SessionWidget extends StatefulWidget {
  final Widget child;
  final Function(BuildContext context) onSessionTimeout;
  final Duration duration;
  final StreamController streamController;
  final GlobalKey<NavigatorState> navigatorKey;
  const SessionWidget(
      {super.key,
      required this.child,
      required this.onSessionTimeout,
      required this.duration,
      required this.streamController,
      required this.navigatorKey});

  @override
  State<SessionWidget> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionWidget> {
  Timer? _timer;
  late StreamController streamController;
  void sessionStart() {
    if (!SessionController.startSession) return;
    closeTimer();
    startTimer();
  }

  void startTimer() {
    final context = widget.navigatorKey.currentContext;
    _timer = Timer.periodic(widget.duration, (timer) {
      if (context != null && SessionController.startSession) {
        dev.log("-> Session expired");
        widget.onSessionTimeout(context);
        SessionController().closeLocalSession();
      } else {
        dev.log("-> Please close session controller");
      }
      closeTimer();
    });
  }

  void closeTimer() {
    if (!context.mounted) return;
    if (_timer == null) return;
    _timer!.cancel();
  }

  void streamControllerSetup() {
    streamController = widget.streamController;

    streamController.stream.listen((event) {
      if (event != null && event['timer'] as bool) {
        sessionStart();
      } else {
        closeTimer();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    streamControllerSetup();
    SessionController().initSession(
        navigatorKey: widget.navigatorKey,
        streamController: widget.streamController);
  }

  @override
  void dispose() {
    super.dispose();
    closeTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerSignal: (_) {
          sessionStart();
        },
        onPointerDown: (_) {
          sessionStart();
        },
        onPointerPanZoomStart: (_) {
          sessionStart();
        },
        onPointerPanZoomEnd: (_) {
          sessionStart();
        },
        child: widget.child);
  }
}
