import { common } from '@kit.AbilityKit';
import { FlutterEntry, FlutterManager, FlutterPage, FlutterView, Log } from '@ohos/flutter_ohos';
import { MyFlutterEntry } from './MyFlutterEntry';

@Entry
@Component
struct FlutterEntryWithRouterPage {
  private context = getContext(this) as common.UIAbilityContext
  private flutterEntry: FlutterEntry | null = null;
  private flutterView?: FlutterView

  aboutToAppear() {
    Log.d("Flutter", "Index aboutToAppear===");
    this.flutterEntry = new MyFlutterEntry(getContext(this))
    this.flutterEntry.aboutToAppear()
    this.flutterView = this.flutterEntry.getFlutterView()
  }

  aboutToDisappear() {
    Log.d("Flutter", "Index aboutToDisappear===");
    this.flutterEntry?.aboutToDisappear()
  }

  // Navigation的生命周期是onShown
  onPageShow() {
    Log.d("Flutter", "Index onPageShow===");
    FlutterManager.getInstance().setUseFullScreen(true)
    this.flutterEntry?.onPageShow()
  }

  // Navigation的生命周期是onHidden
  onPageHide() {
    Log.d("Flutter", "Index onPageHide===");
    FlutterManager.getInstance().setUseFullScreen(false)
    this.flutterEntry?.onPageHide()
  }

  onBackPress(): boolean | void {
    this.context.eventHub.emit('EVENT_BACK_PRESS')
    return true
  }

  build() {
    Stack() {
      FlutterPage({ viewId: this.flutterView?.getId() })
    }

  }
}