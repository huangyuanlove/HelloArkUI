import { HMPopInfo, HMRouterMgr } from '@hadss/hmrouter'
import { JSON } from '@kit.ArkTS'
import { FlutterAbilityLaunchConfigs } from '@ohos/flutter_ohos'

export enum FlutterPath {
  MAIN = 'main',
  LOGIN = 'login',
  TEST = 'test',
  ROOT = '/'
}


export class MyFlutterRouter {
  static push(path: FlutterPath, params: Record<string, Object> | undefined = undefined) {
    let target: string = path.toString()
    if (params) {
      target = `${target}?${JSON.stringify(params)}`
    }
    let routerParams:Record<string,string>= {}
    routerParams[FlutterAbilityLaunchConfigs.EXTRA_INITIAL_ROUTE] = target;

    HMRouterMgr.push({ pageUrl: 'pages/flutter/MyFlutterPage', param: routerParams }, {
      onResult: (popInfo: HMPopInfo) => {
        console.error(`获取到页面返回时携带的参数 ${JSON.stringify(popInfo.result)}`)
      },
      onArrival: () => {
      }
    })
  }
}