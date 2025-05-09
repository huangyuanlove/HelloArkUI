import { ActionBar } from '../../comm/ActionBar';
import deviceInfo from '@ohos.deviceInfo'
@Component
@Entry
struct ImageScaleWithGesture {
  @State scaleValue: number = 1
  @State pinchValue: number = 1
  @State pinchX: number = 0
  @State pinchY: number = 0

  onPageShow(){
    console.error("onPageShow--> " + deviceInfo.deviceType )
  }


  build() {
    Column() {
      ActionBar({ title: "图片手势缩放" })
      Image($r("app.media.cat")).objectFit(ImageFit.Contain).autoResize(false).fitOriginalSize(true)
        .gesture(PinchGesture({ fingers: 2 })
        .onActionStart((event: GestureEvent) => {
          console.info('Pinch start')
        })
        .onActionUpdate((event: GestureEvent) => {
          this.scaleValue = this.pinchValue * event.scale
          this.pinchX = event.pinchCenterX
          this.pinchY = event.pinchCenterY
        })
        .onActionEnd(() => {
          this.pinchValue = this.scaleValue
          console.info('Pinch end')
        }))
    }
  }
}