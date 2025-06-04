import 'dart:convert';

import 'package:flutter/material.dart';

typedef RouteWidgetBuilder = Widget Function(dynamic args);

class RouterManager {
  static final RouterManager _instance = RouterManager();

  static RouterManager get instance => _instance;

  final Map<String, RouteWidgetBuilder> _routerMap = {};

  bool addRouter(String path, RouteWidgetBuilder routerBuilder) {
    _routerMap[path] = routerBuilder;
    return true;
  }
  bool hasRouterWidget(String path){
    final String routerName = _getRouterName(path);
    return _routerMap.containsKey(routerName);
  }

  Widget getRouterWidget(String path) {
    final String routerName = _getRouterName(path);
    final Object? params = _getRouteArgs(path);
    debugPrint(
        "getRouterWidget path:${path}, routerName:$routerName,params:$params");
    RouteWidgetBuilder? routerBuilder = _routerMap[routerName];
    if (routerBuilder != null) {
      return routerBuilder(params);
    }
    return Container();
  }

  String _getRouterName(String? path) {
    if (path == null) {
      debugPrint("获取路径出错，path 为空");
      return "/";
    }
    if (path.contains('?')) {
      var uri = Uri.parse(path);
      return uri.path;
    } else {
      return path;
    }
  }

  Object? _getRouteArgs(String? route) {
    if (route == null) {
      return null;
    }

    if (route.contains('?')) {
      var uri = Uri.parse(route);

      String query = uri.query;
      try {
        query = Uri.decodeFull(query);
        return json.decode(query);
      } catch (e) {
        // Map<String, String>
        return Uri.splitQueryString(query);
      }
    } else {
      return null;
    }
  }
}
