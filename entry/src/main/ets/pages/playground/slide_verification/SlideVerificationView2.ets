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




        let imageBitMap: ImageBitmap = new ImageBitmap("pages/playground/cat.webp")
        this.canvasRendering.drawImage(imageBitMap, 0, 0)

        hilog.error(0x01, 'SlideVerificationView2', 'imageBitMap width --> ' + imageBitMap.width)
        hilog.error(0x01, 'SlideVerificationView2', 'imageBitMap height --> ' + imageBitMap.height)


        this.clip_start_x = Math.floor(Math.random() * (imageBitMap.width - this.clip_image_width))
        this.clip_start_y = Math.floor(Math.random() * (imageBitMap.height - this.clip_image_height))

        hilog.error(0x01, 'SlideVerificationView2', 'clip_start_x --> ' + this.clip_start_x)
        hilog.error(0x01, 'SlideVerificationView2', 'clip_start_y --> ' + this.clip_start_y)


        this.canvasRendering.lineWidth = 2

        this.canvasRendering.strokeStyle = '#FFFFFF'

        //在对应的区域绘制标识
        this.canvasRendering.moveTo(this.clip_start_x + this.clip_image_width / 2, this.clip_start_y)
        this.canvasRendering.lineTo(this.clip_start_x + this.clip_image_width,
          this.clip_start_y + this.clip_image_height)
        this.canvasRendering.lineTo(this.clip_start_x, this.clip_start_y + this.clip_image_height)
        this.canvasRendering.lineTo(this.clip_start_x + this.clip_image_width / 2, this.clip_start_y)
        this.canvasRendering.stroke()


      })
      Canvas(this.canvasRendering2).width("100%").height("100%").onReady(() => {

      })
        .priorityGesture(
          PanGesture()
            .onActionStart((event: GestureEvent) => {

            })
            .onActionUpdate((event: GestureEvent) => {
              hilog.error(0x01, 'SlideVerificationView2', event.offsetX.toString())
              this.canvasRendering2.reset()

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