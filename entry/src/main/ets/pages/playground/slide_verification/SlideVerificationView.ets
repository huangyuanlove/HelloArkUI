import { hilog } from "@kit.PerformanceAnalysisKit"
import { promptAction } from "@kit.ArkUI"

@Component
export struct SlideVerificationView {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasRendering2: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private diffInterval: number = 10
  private clip_start_x: number = 100
  private clip_start_y: number = 100
  private clip_image_width = 120
  private clip_image_height = 120
  private imageData?: ImageData

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

        this.imageData = this.canvasRendering.getImageData(this.clip_start_x, this.clip_start_y, this.clip_image_width, this.clip_image_height)

        //在对应的区域绘制标识
        this.canvasRendering.lineWidth = 2
        this.canvasRendering.fillStyle = '#66FFFFFF'
        this.canvasRendering.moveTo(this.clip_start_x + this.clip_image_width / 2, this.clip_start_y)
        this.canvasRendering.lineTo(this.clip_start_x + this.clip_image_width, this.clip_start_y + this.clip_image_height)
        this.canvasRendering.lineTo(this.clip_start_x, this.clip_start_y + this.clip_image_height)
        this.canvasRendering.lineTo(this.clip_start_x + this.clip_image_width / 2, this.clip_start_y)
        this.canvasRendering.fill()

        //将ImageData处理成三角形
        if(this.imageData){
          let width = this.imageData.width * 4
          let height = this.imageData.height
          let rate = width / height
          let widthCenter = Math.floor(width / 2)
          for (let i = 0; i < height; i++) {
            //第几行

            for (let j = 0; j < width; j++) {
              //第几列
              if (j < widthCenter - rate * i / 2) {
                this.imageData.data[i * width +j] = 0
              } else if (j > widthCenter + rate * i / 2) {
                this.imageData.data[i * width +j] = 0
              }

            }
          }
        }
      })
      Canvas(this.canvasRendering2).width("100%").height("100%").onReady(() => {
      })
        .priorityGesture(
          PanGesture()
            .onActionStart((event: GestureEvent) => {
            })
            .onActionUpdate((event: GestureEvent) => {
              hilog.error(0x01, 'SlideVerificationView', event.offsetX.toString())

              if (this.imageData) {
                this.canvasRendering2.reset()
                this.canvasRendering2.putImageData(this.imageData, event.offsetX, this.clip_start_y)
              }
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