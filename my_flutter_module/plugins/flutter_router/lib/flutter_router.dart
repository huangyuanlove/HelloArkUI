import 'package:flutter/material.dart';
import 'flutter_router_platform_interface.dart';
import 'router_manager.dart';

class FlutterRouter {
  Future<String?> getPlatformVersion() {
    return FlutterRouterPlatform.instance.getPlatformVersion();
  }

  Future<T?> open<T extends Object?>(context, path,
      {Object? arguments}) async {
    final bool useFlutterPage = RouterManager.instance.hasRouterWidget(path);
      if(useFlutterPage){
        debugPrint("FlutterRouter#open 打开 flutter");
        Widget target =  RouterManager.instance.getRouterWidget(path,params: arguments);
       return Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => target,
        ),);
      // return Navigator.of(context).pushNamed(path, arguments: arguments);
    } else {
      // 打开native页面: path已在native端注册
        debugPrint("FlutterRouter#open 打开 native");
      return FlutterRouterPlatform.instance
          .open<T>(path, arguments: arguments)
          .then((value) {
        return value;
      });
    }
  }

  void pop(context, [dynamic args]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(args);
    } else {
      FlutterRouterPlatform.instance.pop(args);
    }
  }
}
