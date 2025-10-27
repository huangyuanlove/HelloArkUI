import { ActionBar } from '../../../comm/ActionBar';

@Entry
@Component
struct Log4aPage {
  @State message: string = 'Hello World';

  build() {

    Column(){
      ActionBar({ title: "Log4a" })
      RelativeContainer() {
        Text(this.message)
          .id('Log4aPageHelloWorld')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.message = 'Welcome';
          })
      }
    }


    .height('100%')
    .width('100%')
  }
}