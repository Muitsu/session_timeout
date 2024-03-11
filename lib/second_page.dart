import 'package:flutter/material.dart';
import 'session-manager/session.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  void initState() {
    super.initState();
    SessionController().openSession();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
