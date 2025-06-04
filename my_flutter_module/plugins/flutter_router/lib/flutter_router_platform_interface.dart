import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_router_method_channel.dart';

abstract class FlutterRouterPlatform extends PlatformInterface {
  /// Constructs a FlutterRouterPlatform.
  FlutterRouterPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterRouterPlatform _instance = MethodChannelFlutterRouter();

  /// The default instance of [FlutterRouterPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterRouter].
  static FlutterRouterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterRouterPlatform] when
  /// they register themselves.
  static set instance(FlutterRouterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<T> open<T extends Object?>(url,
      {dynamic arguments, Map? containerConf}) {
    throw UnimplementedError('open() has not been implemented.');
  }

  void pop([args]) {
    throw UnimplementedError('open() has not been implemented.');
  }
}
