import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import { ActionBar } from "../../comm/ActionBar";
import { UIUtils } from "@kit.ArkUI";

@HMRouter({ pageUrl: 'pages/flutter/FromFlutterPage' })
@Component
export struct FromFlutterPage {
  @State routerParam: Map<string, Object> | undefined = undefined

  aboutToAppear(): void {
    this.routerParam = HMRouterMgr.getCurrentParam() as Map<string, Object>
  }

  build() {
    Column() {
      ActionBar({ title: "从 flutter 打开的页面",onClickBack:(_)=>{HMRouterMgr.pop()} })

      Text('获取到的路由参数')
      Text(this.routerParamsToStr())

      Button("返回上个页面，携带参数").onClick((_)=>{
        HMRouterMgr.pop({param:{'success':true,'message':"ok"}})
      })

    }
  }

  routerParamsToStr(): string {
    if (this.routerParam) {
      let result = ''

      let tmp:Map<string,Object> = UIUtils.getTarget<Map<string,Object>>(this.routerParam);
      tmp.forEach((value,key)=>{
        result += `${key} : ${value} \n`
      })

      return result

    } else {
      return "无参数"
    }
  }
}