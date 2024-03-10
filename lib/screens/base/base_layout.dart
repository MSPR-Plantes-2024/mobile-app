import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseLayout extends StatefulWidget {
  final Widget child;
  const BaseLayout({super.key, required this.child});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  late String previousRoute;
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
                  context.push('/user');
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
                  visible: value == '/' || value == '/my_publications'
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
        body: widget.child);
  }
}
