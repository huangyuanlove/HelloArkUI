import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'my_router_channel.dart';
import 'router_manager.dart';





class MyRoute {
  Future<T?> open<T extends Object?>(context, path,
      {Object? arguments, CyContainerConf? containerConf}) async {
    final route = RouteManager.instance.getRoute(path);
    if (route != null) {
      if (containerConf != null) {
        // 需要用新的container打开flutter页面
        return MyRouteChannel.instance
            .open<T>(path,
                arguments: arguments, containerConf: containerConf.toJson())
            .then((value) {
          return value;
        });
      }
      return Navigator.of(context).pushNamed(path, arguments: arguments);
    } else {
      // 打开native页面: path已在native端注册
      return MyRouteChannel.instance
          .open<T>(path, arguments: arguments, containerConf: null)
          .then((value) {
        return value;
      });
    }
  }

  void pop(context, [dynamic args]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(args);
    } else {
      // SystemNavigator.pop(animated: true);
      MyRouteChannel.instance.pop(args);
    }
  }

  void canFlutterPop(Map<String, dynamic> params) {
    if (Platform.isIOS) {
      // CyRoutePlatform.instance.canFlutterPop(params);
    }
  }

  static String? getRoute(String? route) {
    if (route == null) {
      return route;
    }
    if (route.contains('?')) {
      var uri = Uri.parse(route);

      return uri.path;
    } else {
      return route;
    }
  }

  /**
   * 目前只支持route=path?json的形式
   */
  static Object? getRouteArgs(String? route) {
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

class CyContainerConf {
  Map toJson() {
    return {};
  }
}
