import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lifecycle/lifecycle.dart';

import 'my_router/my_route_listen_widget.dart';
import 'my_router/my_router.dart';
import 'my_router/route_config.dart';
import 'my_router/router_manager.dart';
import 'oh_channel/OHChannel.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  new OHChannel().init();
  print("Future<void> main()");
  setupRoutes();
  WidgetsBinding.instance.addObserver(MyWidgetsBindingObserver());
  final initialRoute = window.defaultRouteName;
  runApp(widgetForRoute(initialRoute));

}

Widget widgetForRoute(String route) {
  Widget w = RouteManager.instance.widgetForRoute(route, null) ?? Container(child: Text("没有找到对应路由"),);

  return MainAppWidget(w: w);
}

class MainAppWidget extends StatefulWidget {
  Widget w;

  MainAppWidget({required this.w, Key? key}) : super(key: key);

  @override
  State<MainAppWidget> createState() => _MainAppWidgetState();
}

class _MainAppWidgetState extends State<MainAppWidget>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        defaultLifecycleObserver,
        MyRouteListenWidget.routeObserver,
      ],
      home: widget.w,
      navigatorKey: Global.navigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      onGenerateRoute: (settings) {
        print('settings: $settings');

        final builder = RouteManager.instance
            .widgetBuilder(settings.name, settings.arguments);

        if (builder == null) {
          return null;
        }

        return CupertinoPageRoute(
            builder: (ctx) => builder(ctx), settings: settings);
      },
      builder: EasyLoading.init(),
    );
  }
}

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

class MyWidgetsBindingObserver extends WidgetsBindingObserver {
  @override
  Future<bool> didPopRoute() {
    BuildContext? context = Global.navigatorKey.currentState!.context;
    MyRoute().pop(context);
    return Future.value(true);
  }
}
