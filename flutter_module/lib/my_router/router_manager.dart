import 'package:flutter/material.dart';

import 'my_router.dart';





typedef RouteArgParser = dynamic Function(dynamic args);
typedef RouteArgDesc = String Function();

typedef RouteWidgetBuilder = Widget Function(
    BuildContext? ctx, String? route, dynamic args);

typedef WidgetBuilderAdapter = Widget Function(BuildContext? ctx);

class RouteO {
  static const String DEFAULT = 'DEFAULT';

  RouteO(this.path, this.builder, {this.argParser, this.argDesc});

  final String path;

  final RouteWidgetBuilder builder;

  final RouteArgParser? argParser;

  final RouteArgDesc? argDesc;
}

class RouteManager {
  static RouteManager _instance = RouteManager();

  static RouteManager get instance => _instance;

  Map<String, RouteO> routeMap = {};

  Widget? widgetForRoute(String? path, dynamic args) {
    final builder = _widgetBuilder(path, args);

    if (builder != null) {
      return builder(null);
    }

    return null;
  }

  WidgetBuilder? widgetBuilder(String? path, dynamic args) {
    final builder = _widgetBuilder(path, args);

    if (builder != null) {
      return (ctx) => builder(ctx);
    }

    return null;
  }

  WidgetBuilderAdapter? _widgetBuilder(String? path, dynamic args) {
    final name = MyRoute.getRoute(path);

    final route = getRoute(name) ?? getRoute(RouteO.DEFAULT);

    if (route != null) {
      args = args ?? MyRoute.getRouteArgs(path);

      if (route.argParser != null) {
        args = route.argParser!(args);
      }

      return (ctx) => route.builder(ctx, name, args);
    }

    return null;
  }

  void addRoutes(routes) {
    for (RouteO route in routes) {
      routeMap[route.path] = route;
    }
  }

  RouteO? getRoute(String? name) {
    return routeMap[name];
  }

  List<RouteO> get routes => routeMap.values.toList();
}
