import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/screens/base/address_creation_page.dart';
import 'package:mobile_app_arosaje/screens/base/address_managment_page.dart';
import 'package:mobile_app_arosaje/screens/base/base_layout.dart';
import 'package:mobile_app_arosaje/screens/base/chat_list_page.dart';
import 'package:mobile_app_arosaje/screens/base/chat_page.dart';
import 'package:mobile_app_arosaje/screens/base/create_report_page.dart';
import 'package:mobile_app_arosaje/screens/base/details_publication_page.dart';
import 'package:mobile_app_arosaje/screens/base/home_page.dart';
import 'package:mobile_app_arosaje/screens/base/request_creation_page.dart';
import 'package:mobile_app_arosaje/screens/base/user_page.dart';
import 'package:mobile_app_arosaje/screens/login/account_creation_page.dart';
import 'package:mobile_app_arosaje/screens/login/login_layout.dart';
import 'package:mobile_app_arosaje/screens/login/login_page.dart';

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
  //
  late GoRouter _router;

  initializeGoRouter() {
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => MyApp.currentUser != null
                  ? HomePage(
                      key: ValueKey(state.name),
                      myPublications: false,
                    )
                  : const LoginPage(),
            ),
            GoRoute(
              path: '/account-creation',
              builder: (context, state) => const AccountCreationPage(),
            ),
            GoRoute(
              path: '/my_publications',
              builder: (context, state) => HomePage(
                key: ValueKey(state.name),
                myPublications: true,
              ),
            ),
            GoRoute(
              path: '/user',
              builder: (context, state) => const UserPage(),
            ),
            GoRoute(
              path: '/request-creation',
              builder: (context, state) => const RequestCreationPage(),
            ),
            GoRoute(
                path: '/address-managment',
                builder: (context, state) {
                  return AddressManagmentPage(
                      map: state.extra as Map<String, dynamic>);
                }),
            GoRoute(
                path: '/address-creation',
                builder: (context, state) => AddressCreationPage(
                    map: state.extra as Map<String, dynamic>)),
            GoRoute(
                path: '/details-publication',
                builder: (context, state) {
                  return DetailsPublicationPage(
                      map: state.extra as Map<String, dynamic>);
                }),
            GoRoute(
              path: '/chat-list',
              builder: (context, state) => const ChatListPage(),
            ),
            GoRoute(
                path: '/chat',
                builder: (context, state) {
                  return ChatPage(map: state.extra as Map<String, dynamic>);
                }),
            GoRoute(
                path: '/create-report',
                builder: (context, state) {
                  return CreateReportPage(
                      map: state.extra as Map<String, dynamic>);
                }),
          ],
          builder: (context, state, child) => MyApp.currentUser != null
              ? BaseLayout(child: child)
              : LoginLayout(child: child),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeGoRouter();
    return MaterialApp.router(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink()),
      title: 'Arosa\'je',
      color: Colors.white,
      routerConfig: _router,
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
