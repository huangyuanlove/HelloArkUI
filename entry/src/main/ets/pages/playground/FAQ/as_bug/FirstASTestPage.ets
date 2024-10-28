import { User } from './UseASPage';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct FirstASTestPage {
  @State message: string = '带参数跳转';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('FirstASTestPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        }).onClick((_)=>{
          let userParam = new User()
        userParam.name = 'FirstASTestPage'
        router.pushUrl({url:'pages/playground/FAQ/as_bug/UseASPage',params:userParam})
      })
    }
    .height('100%')
    .width('100%')
  }
}