import 'package:flutter/material.dart';

class RouteObserverBody extends NavigatorObserver {
  final ValueNotifier<String> routeNameNotifier;

  RouteObserverBody(this.routeNameNotifier);

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    routeNameNotifier.value = previousRoute?.settings.name ?? '/';
  }
}
