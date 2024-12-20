import { HMDefaultGlobalAnimator, HMNavigation, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { AttributeUpdater } from '@kit.ArkUI';
import { PageDurationLifecycle } from './hmrouter/PageDurationLifecycle';


@HMRouter({
  pageUrl: 'pages/playground/hmrouter_page/HMRouterAPage',
  lifecycle: 'PageDurationLifecycle',
  animator: 'liveCommentsAnimator'
})
@Component
export struct HMRouterAPage {
  @State message: string = 'Hello World';
  @State params: Record<string, Object> = HMRouterMgr.getCurrentParam() as Record<string, Object>
  @State time: number = (HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle() as PageDurationLifecycle).time

  build() {
    Column() {

      Column() {
        if (this.params) {
          Text(JSON.stringify(this.params))
          Text(this.time.toString())
        }
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .width('100%')
  }
}
