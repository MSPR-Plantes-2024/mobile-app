import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/screens/home_page.dart';
import 'package:mobile_app_arosaje/screens/user_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Arosa\'je', color: Colors.white, home: const BaseLayout());
  }
}

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ValueNotifier<String> _routeNameNotifier = ValueNotifier<String>('/');

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
          title: const Center(
            child: SizedBox(
              height: 65,
              child: Image(
                image: AssetImage("assets/images/logo.png"),
                height: 61,
              ),
            ),
          ),
          actions: const [
            Padding(
                padding: EdgeInsets.all(15.0),
                child: Icon(
                  Icons.chat_outlined,
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
                visible: value == '/' ? true : false,
                child: FloatingActionButton(
                    onPressed: () {}, child: const Icon(Icons.add)));
          }),
      bottomNavigationBar: Builder(builder: (context) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, -3), // changes position of shadow
              ),
            ],
          ),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            elevation: 8.0,
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Container(
                      child: Text("Publications", textAlign: TextAlign.center),
                    ),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Ink(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: InkWell(
                            child: const Icon(Icons.search,
                                size: 30.0, color: Colors.black)),
                      ),
                    ),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: Container(
                      child: Text(
                        "Mes\nPublications",
                        textAlign: TextAlign.center,
                      ),
                    ),
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
          onGenerateRoute: (RouteSettings settings) {
            _routeNameNotifier.value = settings.name!;
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                builder = (BuildContext _) => const HomePage();
                break;
              case '/user':
                builder = (BuildContext _) => const UserPage();
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
