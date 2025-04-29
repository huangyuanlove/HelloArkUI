import { FlutterPage, FlutterPluginBinding, MethodCall, MethodChannel, MethodResult } from "@ohos/flutter_ohos";
import { AppInfoPlugin } from "./plugins/AppInfoPlugin";

export class MyFlutterPlugin extends FlutterPage{
  private channel?: MethodChannel;

  getUniqueClassName(): string {
    return 'CYFlutterPlugin'
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), 'com.chunyu.clinic/method');
    let that = this;
    this.channel.setMethodCallHandler({
      onMethodCall(call: MethodCall, result: MethodResult) {
        console.warn('接到flutter请求:' + call.method + call.args)
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