import 'dart:developer';

import 'package:flutter/material.dart';

import 'account_creation_page.dart';
import 'login_page.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout({super.key});

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
      body: NavigatorPopHandler(
        onPop: () => loginNavigatorKey.currentState!.pop(),
        child: Navigator(
          initialRoute: 'login',
          key: loginNavigatorKey,
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            log(settings.name!);
            switch (settings.name) {
              case 'login':
                builder = (BuildContext _) => const LoginPage();
                break;
              case 'account-creation':
                builder = (BuildContext _) => const AccountCreationPage();
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
      ),
    );
  }
}
