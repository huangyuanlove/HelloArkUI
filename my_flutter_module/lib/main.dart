import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_router/router_manager.dart';
import 'package:my_flutter_module/router/init_router.dart';

void main() {
  initRouter();
  var routerName = PlatformDispatcher.instance.defaultRouteName;
  debugPrint("获取到需要加载的路径：${routerName}");
  runApp(MyApp(path: routerName));
}

class MyApp extends StatelessWidget {
  final String path;
  const MyApp({required this.path, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RouterManager.instance.getRouterWidget(path),
    );

  }
}
