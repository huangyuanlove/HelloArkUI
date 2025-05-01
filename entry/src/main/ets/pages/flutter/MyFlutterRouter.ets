import { HMPopInfo, HMRouterMgr } from '@hadss/hmrouter'
import { JSON } from '@kit.ArkTS'

export enum FlutterPath {
  MAIN = 'main',
  LOGIN = 'login',
  TEST = 'test'
}


export class MyFlutterRouter {
  static push(path: FlutterPath, params: Record<string,Object> | undefined = undefined) {
    let target = path.toString()
    if (params) {
      target += `?${MyFlutterRouter.parseParams(params)}`
    }
    HMRouterMgr.push({ pageUrl: 'pages/flutter/MyFlutterPage', param: { 'path': target } },{
      onResult:(popInfo: HMPopInfo) => {

        console.error(`获取到页面返回时携带的参数 ${JSON.stringify(popInfo.result)}`)
      },
      onArrival:()=>{

      }
    })
  }

  private static parseParams(params: Record<string,Object>): string {
    return JSON.stringify(params)
  }
}