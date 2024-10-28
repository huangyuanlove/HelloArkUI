import { showDialog } from './DialogControllerUtils';

@Entry
@Component
struct DialogControllerPage {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('DialogControllerPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        }).onClick((_)=>{
          showDialog()
      })
    }
    .height('100%')
    .width('100%')
  }
}