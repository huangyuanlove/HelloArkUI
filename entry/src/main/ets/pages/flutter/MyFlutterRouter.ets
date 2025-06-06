import { HMPopInfo, HMRouterMgr, HMRouterPathCallback } from '@hadss/hmrouter'
import { JSON } from '@kit.ArkTS'
import { FlutterAbilityLaunchConfigs } from '@ohos/flutter_ohos'

export enum FlutterPath {
  MAIN = 'main',
  LOGIN = 'login',
  TEST = 'test',
  ROOT = '/'
}


export class MyFlutterRouter {
  static push(path: FlutterPath, params: Record<string, Object> | undefined = undefined,
    callback?: HMRouterPathCallback) {
    let target: string = path.toString()
    if (params) {
      target = `${target}?${JSON.stringify(params)}`
    }
    let routerParams: Record<string, string> = {}
    routerParams[FlutterAbilityLaunchConfigs.EXTRA_INITIAL_ROUTE] = target;

    HMRouterMgr.push({ pageUrl: 'pages/flutter/MyFlutterPage', param: routerParams }, {
      onResult: (popInfo: HMPopInfo) => {
        console.error(`获取到页面返回时携带的参数 ${JSON.stringify(popInfo.result)}`)
        if (callback && callback.onResult) {
          callback.onResult(popInfo)
        }
      },
      onArrival: () => {
        if (callback && callback.onArrival) {
          callback.onArrival()
        }
      },
      onLost: () => {
        if (callback && callback.onLost) {
          callback.onLost()
        }
      }
    })
  }
}