import { HMRouterMgr } from '@hadss/hmrouter'
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
    HMRouterMgr.push({ pageUrl: 'pages/flutter/CYFlutterPage', param: { 'path': target } })
  }

  private static parseParams(params: Record<string,Object>): string {
    return JSON.stringify(params)
  }
}