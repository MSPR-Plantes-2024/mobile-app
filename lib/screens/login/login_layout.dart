import 'package:flutter/material.dart';

class LoginLayout extends StatefulWidget {
  final Widget child;
  const LoginLayout({super.key, required this.child});

  @override
  _LoginLayoutState createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  final GlobalKey<NavigatorState> loginNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
              child: InkWell(
                child: SizedBox(
                  height: 65,
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                    height: 61,
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 5,
            shadowColor: Colors.black,
          ),
        ),
        body: widget.child);
  }
}
