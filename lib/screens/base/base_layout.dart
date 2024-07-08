import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseLayout extends StatefulWidget {
  final Widget child;
  const BaseLayout({super.key, required this.child});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  late ValueNotifier<String> _routeNameNotifier = ValueNotifier<String>('/');
  late int bottomNavigationBarIndex = 0;

  @override
  Widget build(BuildContext context) {;
    _routeNameNotifier.value = GoRouterState.of(context).fullPath ?? '/';
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            leading: IconButton(
                onPressed: () {
                  context.push('/user');
                },
                icon: const Icon(Icons.account_circle_outlined)),
            title: Center(
              child: Container(
                  padding: const EdgeInsets.only(right: 8),
                  height: 60,
                  child: const Image(
                    image: AssetImage("assets/images/logo.png"),
                    height: 60,
                  ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push("/chat-list");
                },
                icon: const Icon(Icons.chat_outlined),
              )
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
                  visible: value == '/' || value == '/my-publications'
                      ? true
                      : false,
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
                  context.go('/my-publications');
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
        body: widget.child);
  }
}
