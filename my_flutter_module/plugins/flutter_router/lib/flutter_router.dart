
import 'flutter_router_platform_interface.dart';

class FlutterRouter {
  Future<String?> getPlatformVersion() {
    return FlutterRouterPlatform.instance.getPlatformVersion();
  }

  Future<T?> open<T extends Object?>(context, path,
      {Object? arguments, CyContainerConf? containerConf}) async {
    final route = RouteManager.instance.getRoute(path);
    if (route != null) {
      if (containerConf != null) {
        // 需要用新的container打开flutter页面
        return CyRoutePlatform.instance
            .open<T>(path,
            arguments: arguments, containerConf: containerConf.toJson())
            .then((value) {
          return value;
        });
      }
      return Navigator.of(context).pushNamed(path, arguments: arguments);
    } else {
      // 打开native页面: path已在native端注册
      return CyRoutePlatform.instance
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
      CyRoutePlatform.instance.pop(args);
    }
  }
}
