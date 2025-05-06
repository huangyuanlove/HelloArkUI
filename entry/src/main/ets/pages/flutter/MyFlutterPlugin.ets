import { FlutterPlugin, FlutterPluginBinding, MethodCall, MethodChannel, MethodResult } from "@ohos/flutter_ohos";
import { AppInfoPlugin } from "./plugins/AppInfoPlugin";

export class MyFlutterPlugin implements FlutterPlugin{
  private channel?: MethodChannel;

  getUniqueClassName(): string {
    return 'MyFlutterPlugin'
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    console.error("MyFlutterPlugin onAttachedToEngine")
    this.channel = new MethodChannel(binding.getBinaryMessenger(), 'com.huangyuanlove.demo/method');
    this.channel.setMethodCallHandler({
      onMethodCall(call: MethodCall, result: MethodResult) {
        console.warn('接到flutter请求:' + call.method + JSON.stringify(call.args))
        switch (call.method) {
          case 'getVersion':
            AppInfoPlugin.handleCall(call, result)
            break

          default:
            result.notImplemented();
            break
        }
      }
    })
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.channel?.setMethodCallHandler(null)
  }
}