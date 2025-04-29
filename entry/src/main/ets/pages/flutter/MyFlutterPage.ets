import { FlutterManager, FlutterPage, FlutterView } from '@ohos/flutter_ohos'
import common from '@ohos.app.ability.common'
import { HMLifecycleState, HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { MyFlutterEntry } from './MyFlutterEntry'

@HMRouter({ pageUrl: 'pages/flutter/MyFlutterPage' })
@Component
export struct MyFlutterPage {
  @State viewId: string = ''
  private context = getContext(this) as common.UIAbilityContext
  private flutterEntry: MyFlutterEntry | null = null;
  private flutterView?: FlutterView

  aboutToAppear() {
    let param: Record<string, string> = HMRouterMgr.getCurrentParam() as Record<string, string>
    let path: string = param['path']
    this.flutterEntry = new MyFlutterEntry(getContext(this), {
      'route': path,
    })
    this.flutterEntry.getInitialRoute()
    this.flutterEntry.aboutToAppear()
    this.flutterView = this.flutterEntry.getFlutterView()
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onShown, () => {
      this.flutterEntry?.onPageShow()
      FlutterManager.getInstance().setUseFullScreen(true)
    })
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onHidden, () => {
      this.flutterEntry?.onPageHide()
      FlutterManager.getInstance().setUseFullScreen(false)
    })
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onBackPressed, (): boolean => {
      this.flutterEntry?.onBackPress()
      return true
    })
  }

  aboutToDisappear() {
    this.flutterEntry?.aboutToDisappear()
  }

  build() {
    Stack() {
      FlutterPage({
        viewId: this.flutterView?.getId(),
        // checkFullScreen: false,
      })
    }.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}