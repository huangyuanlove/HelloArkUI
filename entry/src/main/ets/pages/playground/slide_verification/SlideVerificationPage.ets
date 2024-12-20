import { SlideVerificationView } from './SlideVerificationView';
import { SlideVerificationView2 } from './SlideVerificationView2';

@Entry
@Component
struct SlideVerificationPage {
  build() {
    Column() {

      SlideVerificationView().backgroundColor(Color.Pink).height(300)
      Divider().height(20).color("#e7e7e7").vertical(false)

      SlideVerificationView2()
    }
    .height('100%')
    .width('100%')
  }
}