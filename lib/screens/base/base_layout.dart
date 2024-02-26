import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/route-observer-body.dart';
import 'package:mobile_app_arosaje/screens/base/address_creation_page.dart';
import 'package:mobile_app_arosaje/screens/base/address_managment_page.dart';
import 'package:mobile_app_arosaje/screens/base/home_page.dart';
import 'package:mobile_app_arosaje/screens/base/request_creation_page.dart';
import 'package:mobile_app_arosaje/screens/base/user_page.dart';

import 'chat_list_page.dart';
import 'chat_page.dart';
import 'details_publication_page.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ValueNotifier<String> _routeNameNotifier = ValueNotifier<String>('/');
  late int bottomNavigationBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                navigatorKey.currentState!.pushNamed('/user');
              },
              icon: const Icon(Icons.account_circle_outlined)),
          title: Center(
            child: InkWell(
              onTap: () {
                navigatorKey.currentState!.pushNamed('/');
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
                    navigatorKey.currentState!.pushNamed('/chat-list');
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
                      navigatorKey.currentState!.pushNamed('/request-creation');
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
                navigatorKey.currentState!.pushNamed('/');
                setState(() {
                  bottomNavigationBarIndex = index;
                });
              } else {
                navigatorKey.currentState!.pushNamed('/my_publications');
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
      body: NavigatorPopHandler(
        onPop: () => navigatorKey.currentState!.pop(),
        child: Navigator(
          key: navigatorKey,
          initialRoute: '/',
          observers: [RouteObserverBody(_routeNameNotifier)],
          onGenerateRoute: (RouteSettings settings) {
            _routeNameNotifier.value = settings.name!;
            WidgetBuilder builder;
            log(settings.name!);
            switch (settings.name) {
              case '/':
                builder = (BuildContext _) => HomePage(
                      key: ValueKey(settings.name),
                      myPublications: false,
                    );
                break;
              case '/my_publications':
                builder = (BuildContext _) => HomePage(
                      key: ValueKey(settings.name),
                      myPublications: true,
                    );
                break;
              case '/user':
                builder = (BuildContext _) => const UserPage();
                break;
              case '/request-creation':
                builder = (BuildContext _) => const RequestCreationPage();
                break;
              case '/address-managment':
                builder = (BuildContext _) => const AddressManagmentPage();
                break;
              case '/address-creation':
                builder = (BuildContext _) => const AddressCreationPage();
                break;
              case '/details-publication':
                builder = (BuildContext _) => const DetailsPublicationPage();
                break;
              case '/chat-list' :
                builder = (BuildContext _) => const ChatListPage();
                break;
                case '/chat' :
                builder = (BuildContext _) => const ChatPage();
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
