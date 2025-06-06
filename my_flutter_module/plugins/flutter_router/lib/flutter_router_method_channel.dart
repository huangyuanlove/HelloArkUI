import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_router_platform_interface.dart';

/// An implementation of [FlutterRouterPlatform] that uses method channels.
class MethodChannelFlutterRouter extends FlutterRouterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_router');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<T> open<T extends Object?>(url,
      {dynamic arguments}) async {
    var args = {};
    args['path'] = url;

    if (arguments != null) {
      args['arguments'] = arguments;
    }
    debugPrint("-----------open---start--------");
    debugPrint("path $url");
    debugPrint("arguments $arguments");
    debugPrint("-----------open----end-------");

    final result = await methodChannel.invokeMethod('open', args);
    return result;
  }

  @override
  void pop([args]) async {
    await methodChannel.invokeMethod('pop', args);
  }

}
