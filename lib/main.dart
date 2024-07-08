import 'dart:developer';

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
import 'package:mobile_app_arosaje/widgets/contextual_dialogs/add_edit_plant.dart';
import 'package:mobile_app_arosaje/widgets/contextual_dialogs/delete_plant.dart';

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
                  routes: [
                    GoRoute(
                      path: 'account-creation',
                      builder: (context, state) => const AccountCreationPage(),
                    ),
                    GoRoute(
                      path: 'my-publications',
                      builder: (context, state) => HomePage(
                        key: ValueKey(state.name),
                        myPublications: true,
                      ),
                    ),
                    GoRoute(
                      path: 'user',
                      builder: (context, state) => const UserPage(),
                    ),
                    GoRoute(
                        path: 'request-creation',
                        builder: (context, state) {
                          return state.extra != null
                              ? RequestCreationPage(
                                  map: state.extra as Map<String, dynamic>)
                              : const RequestCreationPage();
                        }),
                    GoRoute(
                        path: 'address-management',
                        builder: (context, state) {
                          return AddressManagmentPage(
                              map: state.extra as Map<String, dynamic>);
                        },
                        routes: [
                          GoRoute(
                            path: 'delete-plant',
                            pageBuilder:
                                (BuildContext context, GoRouterState state) {
                              return DialogPage(
                                  builder: (_) => DeletePlant(
                                      map:
                                          state.extra as Map<String, dynamic>));
                            },
                          ),
                        ]),
                    GoRoute(
                        path: 'address-creation',
                        builder: (context, state) => AddressCreationPage(
                            map: state.extra as Map<String, dynamic>)),
                    GoRoute(
                        path: 'details-publication',
                        builder: (context, state) {
                          return DetailsPublicationPage(
                              map: state.extra as Map<String, dynamic>);
                        }),
                    GoRoute(
                      path: 'chat-list',
                      builder: (context, state) => const ChatListPage(),
                    ),
                    GoRoute(
                        path: 'chat',
                        builder: (context, state) {
                          return ChatPage(
                              map: state.extra as Map<String, dynamic>);
                        }),
                    GoRoute(
                        path: 'report-creation',
                        builder: (context, state) {
                          return CreateReportPage(
                              map: state.extra as Map<String, dynamic>);
                        }),
                    GoRoute(
                      path: 'add-edit-plant',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        return DialogPage(
                            builder: (_) => AddEditPlant(
                                map: state.extra as Map<String, dynamic>));
                      },
                    ),
                  ]),
            ],
            builder: (context, state, child) {
              log(GoRouterState.of(context).fullPath!);
              return MyApp.currentUser != null
                  ? BaseLayout(child: child)
                  : LoginLayout(child: child);
            }),
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
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreen,
            brightness: Brightness.light,
          )),
      routerConfig: _router,
    );
  }
}

/// A dialog page with Material entrance and exit animations, modal barrier color,
/// and modal barrier behavior (dialog is dismissible with a tap on the barrier).
class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes);
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
