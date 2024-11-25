import { SlideVerificationView } from './SlideVerificationView';

@Entry
@Component
struct SlideVerificationPage {
  build() {
    Column() {

      SlideVerificationView()
    }
    .height('100%')
    .width('100%')
  }
}