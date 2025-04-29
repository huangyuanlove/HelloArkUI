

import 'my_channel.dart';

const String routeChannelName = 'route';

class MyRouteChannel extends MyChannel {
  static final  MyRouteChannel _instance = MyRouteChannel();

  static MyRouteChannel get instance => _instance;

  Future<T> open<T extends Object?>(url,
      {dynamic arguments, Map? containerConf}) async {
    var args = Map();
    args['path'] = url;
    args['action'] = 'push';

    if (arguments != null) {
      args['arguments'] = arguments;
    }

    if (containerConf != null) {
      args['container_conf'] = containerConf;
    }

    final result = await callNative(routeChannelName, args);
    return result;
  }

  void pop([arguments]) async {
    var args = Map();
    args['action'] = 'pop';
    if (arguments != null) {
      args['arguments'] = arguments;
    }

    // await callNative
    await callNative(routeChannelName, args);
  }
}
