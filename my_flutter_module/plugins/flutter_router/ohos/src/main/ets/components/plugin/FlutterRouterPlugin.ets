import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';

/** FlutterRouterPlugin **/
export default class FlutterRouterPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  static routerPushHandler: (path: string, args: Record<string, Object> | undefined) => boolean = (path, args) => {
    return false
  };
  static routerPopHandler:(args:Record<string,Object>|undefined)=>boolean =(args)=>{
    return false
  }

  constructor() {
  }

  static setRouterPushHandler(handler: (path: string, args: Record<string, Object> | undefined) => boolean) {
    FlutterRouterPlugin.routerPushHandler = handler
  }

  getUniqueClassName(): string {
    return "FlutterRouterPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_router");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getPlatformVersion") {
      result.success("OpenHarmony ^ ^ ")
    } else if (call.method == 'open') {
      let path: string = call.argument('path')
      let args: Record<string, Object> | undefined = call.argument('arguments')
      if (FlutterRouterPlugin.routerPushHandler(path, args)) {
        result.success({ "error_code": 0 })
      } else {
        result.success({ "error_code": 1, "error_msg": "打开页面失败" })
      }
    }else if(call.method =='pop'){
      if(FlutterRouterPlugin.routerPopHandler(call.args)){
        result.success({ "error_code": 0 })
      }else{
        result.success({ "error_code": 1, "error_msg": "返回上级页面失败" })
      }

    }
    else {
      result.notImplemented()
    }
  }
}