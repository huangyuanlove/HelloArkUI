
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OHChannel {

  final _channel = const MethodChannel('flutter/navigation');
  init(){
    _channel.setMethodCallHandler((MethodCall call)async{
      print("flutter/navigation 接收到宿主工程的调用 ${call.method}  ${call.arguments}");
      EasyLoading.showToast("${call.method}  ${call.arguments}");
      switch(call.method){
        case "popRoute":
        
        break;
      }
    });
  }
}