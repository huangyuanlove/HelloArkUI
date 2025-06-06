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
  static routerPushHandler: (path: string, args: Record<string, Object> | undefined,result:MethodResult) => boolean = (path, args,result) => {
    return false
  };
  static routerPopHandler:(call:MethodCall,result: MethodResult)=>boolean =(call,result)=>{
    return false
  }

  constructor() {
  }

  static setRouterPushHandler(handler: (path: string, args: Record<string, Object> | undefined,result:MethodResult) => boolean) {
    FlutterRouterPlugin.routerPushHandler = handler
  }
  static setRouterPopHandler(handler:(call:MethodCall,result: MethodResult)=>boolean){
    FlutterRouterPlugin.routerPopHandler = handler
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
      console.error("-------onMethodCall----open---start--------")
      console.error(`path ${path}`)
      console.error(`arguments ${args}`)
      console.error("------onMethodCall-----open----end-------")
      FlutterRouterPlugin.routerPushHandler(path, args,result)

    }else if(call.method =='pop'){
      FlutterRouterPlugin.routerPopHandler(call,result)
    }
    else {
      result.notImplemented()
    }
  }
}