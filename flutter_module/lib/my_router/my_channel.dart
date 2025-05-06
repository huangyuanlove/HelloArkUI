import 'package:flutter/services.dart';

class MyChannel {
  final channel = const MethodChannel('com.huangyuanlove.demo/method');

  Future<T?> callNative<T>(String method, [dynamic params]) {
    return channel.invokeMethod(method, params);
  }
}
