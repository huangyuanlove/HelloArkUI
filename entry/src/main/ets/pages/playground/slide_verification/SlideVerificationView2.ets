import { hilog } from "@kit.PerformanceAnalysisKit"
import { promptAction } from "@kit.ArkUI"

@Component
export struct SlideVerificationView2 {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasRendering2: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private diffInterval: number = 10
  private clip_start_x: number = 100
  private clip_start_y: number = 100
  private clip_image_width = 120
  private clip_image_height = 120

  build() {
    Stack() {
      Canvas(this.canvasRendering).width("100%").height("100%").onReady(() => {

        //这里用的本地图片
        let imageBitMap: ImageBitmap = new ImageBitmap("pages/playground/cat.webp")
        this.canvasRendering.drawImage(imageBitMap, 0, 0)
        hilog.error(0x01, 'SlideVerificationView2', 'imageBitMap width --> ' + imageBitMap.width)
        hilog.error(0x01, 'SlideVerificationView2', 'imageBitMap height --> ' + imageBitMap.height)

        //随机两个坐标，注意不要超出图片范围
        this.clip_start_x = Math.floor(Math.random() * (imageBitMap.width - this.clip_image_width))
        this.clip_start_y = Math.floor(Math.random() * (imageBitMap.height - this.clip_image_height))

        hilog.error(0x01, 'SlideVerificationView2', 'clip_start_x --> ' + this.clip_start_x)
        hilog.error(0x01, 'SlideVerificationView2', 'clip_start_y --> ' + this.clip_start_y)

        this.canvasRendering.lineWidth = 2
        this.canvasRendering.strokeStyle = '#FFFFFF'
        //在对应的区域绘制标识，这里画了个三角形，想画其他的自己调整就好
        this.canvasRendering.moveTo(this.clip_start_x + this.clip_image_width / 2, this.clip_start_y)
        this.canvasRendering.lineTo(this.clip_start_x + this.clip_image_width, this.clip_start_y + this.clip_image_height)
        this.canvasRendering.lineTo(this.clip_start_x, this.clip_start_y + this.clip_image_height)
        this.canvasRendering.lineTo(this.clip_start_x + this.clip_image_width / 2, this.clip_start_y)
        this.canvasRendering.stroke()
      })
      Canvas(this.canvasRendering2).width("100%").height("100%").onReady(() => {

      })
        //绑定优先识别手势
        .priorityGesture(
          //平移手势，滑动最小距离为5vp时识别成功。
          PanGesture()
            .onActionStart((event: GestureEvent) => {

            })
            .onActionUpdate((event: GestureEvent) => {
              //重置一下画布
              this.canvasRendering2.reset()

              //绘制形状，和整图canvas中的形状、大小一致
              this.canvasRendering2.moveTo(event.offsetX + this.clip_image_width/2, this.clip_start_y)
              this.canvasRendering2.lineTo(event.offsetX + this.clip_image_width, this.clip_start_y + this.clip_image_height)
              this.canvasRendering2.lineTo(event.offsetX, this.clip_start_y + this.clip_image_height)
              this.canvasRendering2.lineTo(event.offsetX + this.clip_image_width/2, this.clip_start_y)

              this.canvasRendering2.strokeStyle = Color.Pink
              this.canvasRendering2.lineWidth = 2
              this.canvasRendering2.stroke()

            })
            .onActionEnd((event: GestureEvent) => {
              hilog.error(0x01, 'SlideVerificationView', `onActionEnd ${event.offsetX.toString()}`)
              //判定是否成功
              if (Math.abs(event.offsetX - this.clip_start_x) < this.diffInterval) {
                promptAction.showToast({ message: '验证成功' })
              } else {
                promptAction.showToast({ message: '验证失败' })
                this.canvasRendering2.reset()
              }
            })
        )
    }
  }
}