import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/screens/base/base_layout.dart';
import 'package:mobile_app_arosaje/screens/login/login_layout.dart';

import 'models/user.dart';

void main() {
  runApp(const RestartWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {
  static User? currentUser;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink()),
      title: 'Arosa\'je',
      color: Colors.white,
      home: MyApp.currentUser != null ?  const BaseLayout() : const LoginLayout(),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
