import 'package:flutter/material.dart';

// 路由操作枚举 https://www.jianshu.com/p/3db671476837
enum MyRouteChangeType { push, pop }

// 路由监听widget
class MyRouteListenWidget extends StatefulWidget {
  static RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  final Widget child;

  // 当前页面展示时的回调
  final Function(MyRouteChangeType)? appearHandler;

  // 当前页面消失时的回调
  final Function(MyRouteChangeType)? disappearHandler;

  // 构造方法
  const MyRouteListenWidget(
      {Key? key,
      required this.child,
      this.appearHandler,
      this.disappearHandler})
      : super(key: key);

  @override
  _MyRouteListenWidgetState createState() => _MyRouteListenWidgetState();
}

class _MyRouteListenWidgetState extends State<MyRouteListenWidget>
    with RouteAware {
  @override
  void didChangeDependencies() {
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      MyRouteListenWidget.routeObserver.unsubscribe(this);
      // 注册监听
      MyRouteListenWidget.routeObserver.subscribe(this, route as PageRoute);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // 移除监听
    MyRouteListenWidget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    if (widget.appearHandler != null) {
      widget.appearHandler!(MyRouteChangeType.push);
    }
    super.didPush();
  }

  @override
  void didPop() {
    if (widget.disappearHandler != null) {
      widget.disappearHandler!(MyRouteChangeType.pop);
    }
    super.didPop();
  }

  @override
  void didPushNext() {
    if (widget.disappearHandler != null) {
      widget.disappearHandler!(MyRouteChangeType.push);
    }
    super.didPushNext();
  }

  @override
  void didPopNext() {
    if (widget.appearHandler != null) {
      widget.appearHandler!(MyRouteChangeType.pop);
    }
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
