import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/models/to_pass_map.dart';
import 'package:mobile_app_arosaje/screens/base/address_creation_page.dart';
import 'package:mobile_app_arosaje/screens/base/address_managment_page.dart';
import 'package:mobile_app_arosaje/screens/base/home_page.dart';
import 'package:mobile_app_arosaje/screens/base/request_creation_page.dart';
import 'package:mobile_app_arosaje/screens/base/user_page.dart';

import 'chat_list_page.dart';
import 'chat_page.dart';
import 'create_report_page.dart';
import 'details_publication_page.dart';

class BaseLayout extends StatefulWidget {
  //implement a previousRoute variable to store the previous route
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  late String previousRoute;
  final GlobalKey<NavigatorState> baseLayoutKey = GlobalKey<NavigatorState>();
  final ValueNotifier<String> _routeNameNotifier = ValueNotifier<String>('/');
  late int bottomNavigationBarIndex = 0;
  late GoRouter _routerDelegate;

  initializeGoRouter() {
    _routerDelegate = GoRouter(
      navigatorKey: baseLayoutKey,
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(
            key: ValueKey(state.name),
            myPublications: false,
          ),
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
          builder: (context, state) => UserPage(),
        ),
        GoRoute(
          path: '/request-creation',
          builder: (context, state) => const RequestCreationPage(),
        ),
        GoRoute(
            path: '/address-managment',
            builder: (context, state) {
              ToPassMap map = state.extra as ToPassMap;
              return AddressManagmentPage(originRoute: map.map['originRoute']);
            }),
        GoRoute(
            path: '/address-creation',
            builder: (context, state) {
              ToPassMap map = state.extra as ToPassMap;
              return AddressCreationPage(originRoute: map.map['originRoute']);
            }),
        GoRoute(
            path: '/details-publication',
            builder: (context, state) {
              ToPassMap map = state.extra as ToPassMap;
              return DetailsPublicationPage(
                originRoute: map.map['originRoute'],
                publication: map.map['publication'],
              );
            }),
        GoRoute(
          path: '/chat-list',
          builder: (context, state) => const ChatListPage(),
        ),
        GoRoute(
            path: '/chat',
            builder: (context, state) {
              ToPassMap map = state.extra as ToPassMap;
              return ChatPage(
                  message: map.map['message'],
                  originRoute: map.map['originRoute']);
            }),
        GoRoute(
            path: '/create-report',
            builder: (context, state) {
              ToPassMap map = state.extra as ToPassMap;
              return CreateReportPage(
                  originRoute: map.map['originRoute'],
                  publication: map.map['publication']);
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeGoRouter();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                context.go('/user');
              },
              icon: const Icon(Icons.account_circle_outlined)),
          title: Center(
            child: InkWell(
              onTap: () {
                context.go('/');
              },
              child: const SizedBox(
                height: 65,
                child: Image(
                  image: AssetImage("assets/images/logo.png"),
                  height: 61,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                  onPressed: () {
                    context.push("/chat-list");
                  },
                  icon: const Icon(Icons.chat_outlined),
                ))
          ],
          backgroundColor: Colors.white,
          elevation: 5,
          shadowColor: Colors.black,
        ),
      ),
      floatingActionButton: ValueListenableBuilder<String>(
          valueListenable: _routeNameNotifier,
          builder: (context, value, child) {
            return Visibility(
                visible:
                    value == '/' || value == '/my_publications' ? true : false,
                child: FloatingActionButton(
                    onPressed: () {
                      context.push('/request-creation');
                    },
                    child: const Icon(Icons.add)));
          }),
      bottomNavigationBar: Builder(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, -3), // changes position of shadow
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: bottomNavigationBarIndex,
            onTap: (int index) {
              if (index == 0) {
                context.go('/');
                setState(() {
                  bottomNavigationBarIndex = index;
                });
              } else {
                context.push('/my_publications');
                setState(() {
                  bottomNavigationBarIndex = index;
                });
              }
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 8.0,
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text("Publications",
                        textAlign: TextAlign.center,
                        style: (bottomNavigationBarIndex == 0)
                            ? const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)
                            : const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal)),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Text("Mes\nPublications",
                        textAlign: TextAlign.center,
                        style: (bottomNavigationBarIndex == 1)
                            ? const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)
                            : const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal)),
                  ),
                  label: "")
            ],
          ),
        );
      }),
      body: MaterialApp.router(
        routerConfig: _routerDelegate,
      ),
    );
  }
}
