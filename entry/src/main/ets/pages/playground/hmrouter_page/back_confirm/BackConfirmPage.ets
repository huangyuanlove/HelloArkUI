import { HMLifecycle, HMLifecycleState, HMRouter, HMRouterMgr, IHMLifecycle } from "@hadss/hmrouter";
import { promptAction } from "@kit.ArkUI";
import { ActionBar } from "../../../../comm/ActionBar";
import { PointLifecycle } from "../PointLifecycle";

@HMRouter({ pageUrl: 'back_confirm_page' })
@Component
export struct BackConfirmPage {
  @State interceptBackPress: boolean = true

  aboutToAppear(): void {
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onBackPressed, (): boolean => {
      promptAction.showToast({ message: '点击了返回' })
      return this.interceptBackPress
    })
  }

  build() {
    Column() {
      ActionBar({title:"返回测试"})
      Button('设置不拦截返回').margin(10).onClick((_) => {
        this.interceptBackPress = false

      })
      Button('设置拦截返回').margin(10).onClick((_) => {
        this.interceptBackPress = true
      })
      Button('返回上一页面').onClick((_) => {
        HMRouterMgr.pop()
      })
    }

  }
}