import { LengthMetrics, router } from '@kit.ArkUI';

@Entry
@Component
struct StateManagerV2Page {
  @State message: string = 'Hello World';

  build() {
    Flex({wrap:FlexWrap.Wrap,space:{main:LengthMetrics.vp(5),cross:LengthMetrics.vp(5)}}) {
      Button('ObservedV2 & Trace & Param & Local & Event').onClick((_)=>{
        router.pushUrl({url:"pages/playground/state_manager_v2/ObservedV2TracePage"})
      })

      Button('Provider & Consumer').onClick((_)=>{
        router.pushUrl({url:"pages/playground/state_manager_v2/ProviderConsumerPage"})
      })
    }
    .height('100%')
    .width('100%')
  }
}