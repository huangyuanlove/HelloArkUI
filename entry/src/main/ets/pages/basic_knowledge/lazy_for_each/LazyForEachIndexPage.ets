
import { ActionBar } from '../../../comm/ActionBar'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct LazyForEachIndexPage {


  build() {
    Column() {
     ActionBar({title:"LazyForEach index"})
      Button("demo").onClick((_)=>{
        router.pushUrl({url:"pages/basic_knowledge/lazy_for_each/LazyForEachDemoPage"})
      })
      Button("v1").onClick((_)=>{
        router.pushUrl({url:"pages/basic_knowledge/lazy_for_each/LazyForEachDemoPage"})
      })
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }
}