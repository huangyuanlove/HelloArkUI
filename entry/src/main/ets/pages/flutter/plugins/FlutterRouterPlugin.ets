
import { MethodCall, MethodResult } from '@ohos/flutter_ohos';
import { url } from '@kit.ArkTS';
import { HMRouterMgr } from '@hadss/hmrouter';

export  class FlutterRoutePlugin {
  static async handleCall(call: MethodCall, result: MethodResult) {
    let args: Map<string, object | string> = call.args;
    let action: string = args.get('action') as string
    switch (action) {
      case 'push':
        FlutterRoutePlugin.handlePushAction(args.get('path') as string)
        break
      case 'pop':
        FlutterRoutePlugin.handlePop(args)
        break
      default:
        break
    }
  }

  private static handlePop(args: Map<string, string | object>) {
    //
    let result = args.get('arguments') as Map<string, string | object>

  }

  private static handlePushAction(path: string) {


  }

  private static getUrlParams(urlStr: string): Record<string, string> {
    let urlObj = url.URL.parseURL(urlStr)
    let params: Record<string, string> = {}
    urlObj.params.forEach((value, name, search) => {
      params[name] = value
    })
    return params
  }
}