import { FlutterManager, FlutterPage, FlutterView } from '@ohos/flutter_ohos'
import { HMLifecycleState, HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { MyFlutterEntry } from './MyFlutterEntry'

@HMRouter({ pageUrl: 'pages/flutter/MyFlutterPage' })
@Component
export struct MyFlutterPage {
  private flutterEntry: MyFlutterEntry | null = null;
  private flutterView?: FlutterView

  aboutToAppear() {
    let param: Record<string, string> = HMRouterMgr.getCurrentParam() as Record<string, string>
    console.error(`MyFlutterPage params ${JSON.stringify(param)}`)
    this.flutterEntry = new MyFlutterEntry(getContext(this), param)
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
      // this.flutterEntry?.onBackPress()
      // (getContext(this) as common.UIAbilityContext).eventHub.emit('EVENT_BACK_PRESS')
      HMRouterMgr.pop()
      return true
    })
  }

  aboutToDisappear() {
    this.flutterEntry?.aboutToDisappear()
  }

  build() {

      FlutterPage({ viewId: this.flutterView?.getId() }).expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

  }
}