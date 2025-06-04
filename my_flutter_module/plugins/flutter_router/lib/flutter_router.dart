
import 'flutter_router_platform_interface.dart';

class FlutterRouter {
  Future<String?> getPlatformVersion() {
    return FlutterRouterPlatform.instance.getPlatformVersion();
  }
}
