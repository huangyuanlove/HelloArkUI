import { ActionBar } from '../../../comm/ActionBar';

@Entry
@Component
struct AccessibilityPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      ActionBar({title:"无障碍-屏幕朗读"})
      Scroll(){
        Column(){

        }.justifyContent(FlexAlign.Start)
      }.layoutWeight(1)
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
  }
}