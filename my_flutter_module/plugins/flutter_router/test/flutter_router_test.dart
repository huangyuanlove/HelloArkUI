import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_router/flutter_router.dart';
import 'package:flutter_router/flutter_router_platform_interface.dart';
import 'package:flutter_router/flutter_router_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterRouterPlatform
    with MockPlatformInterfaceMixin
    implements FlutterRouterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterRouterPlatform initialPlatform = FlutterRouterPlatform.instance;

  test('$MethodChannelFlutterRouter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterRouter>());
  });

  test('getPlatformVersion', () async {
    FlutterRouter flutterRouterPlugin = FlutterRouter();
    MockFlutterRouterPlatform fakePlatform = MockFlutterRouterPlatform();
    FlutterRouterPlatform.instance = fakePlatform;

    expect(await flutterRouterPlugin.getPlatformVersion(), '42');
  });
}
