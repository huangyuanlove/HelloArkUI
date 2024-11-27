import { hilog } from "@kit.PerformanceAnalysisKit"

@Component
export struct SlideVerificationView {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasRendering2: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State private canvasWidth: number = 0
  @State private canvasHeight: number = 0
  private path: Path2D = new Path2D()
  private imageData?: ImageData

  build() {
    Stack() {


      Canvas(this.canvasRendering).width("100%").height("100%").onReady(() => {
        this.canvasWidth = this.canvasRendering.width
        this.canvasHeight = this.canvasRendering.height
        let imageBitMap: ImageBitmap = new ImageBitmap("pages/playground/cat.webp")
        this.canvasRendering.drawImage(imageBitMap, 0, 0)
        this.imageData = this.canvasRendering.getImageData(50, 50, 120, 120)


        this.canvasRendering.lineWidth = 2

        this.canvasRendering.fillStyle = '#33FFFFFF'

        //在对应的区域绘制标识
        this.canvasRendering.moveTo(110, 50)
        this.canvasRendering.lineTo(170, 170)
        this.canvasRendering.lineTo(50, 170)
        this.canvasRendering.lineTo(110, 50)
        this.canvasRendering.fill()


      })
      Canvas(this.canvasRendering2).width("100%").height("100%").onReady(() => {
        this.canvasRendering2.fillStyle = "#88e7e7e7"
        // this.canvasRendering2.fillRect(0,0,this.canvasWidth,this.canvasHeight)
      })
        .priorityGesture(
          PanGesture()
            .onActionStart((event: GestureEvent) => {
              // let length = this.imageData?.data.byteLength //608400
              let length = this.imageData?.data.length
              let width = this.imageData?.width
              let height = this.imageData?.height
              let count = (width??0) * (height??0)

                hilog.error(0x01,'SlideVerificationView',`length : ${length}`)
                hilog.error(0x01,'SlideVerificationView',`count : ${count}`)
                hilog.error(0x01,'SlideVerificationView',`widht : ${width}`)
                hilog.error(0x01,'SlideVerificationView',`height : ${height}`)
            })
            .onActionUpdate((event: GestureEvent) => {
              hilog.error(0x01, 'SlideVerificationView', event.offsetX.toString())


              if (this.imageData) {

                this.canvasRendering2.reset()

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

                this.canvasRendering2.putImageData(this.imageData, event.offsetX, 50)


                // let path: Path2D = new Path2D()
                // path.moveTo(event.offsetX + imageWidth / 2, 50)
                // path.lineTo(event.offsetX + imageWidth, 50 + imageHeight)
                // path.lineTo(event.offsetX, 50 + imageHeight)
                // path.lineTo(event.offsetX + imageWidth / 2, 50)
                //
                // path.moveTo(event.offsetX + 120 / 2, 50)
                // path.lineTo(event.offsetX + 120, 50 + 120)
                // path.lineTo(event.offsetX, 50 + 120)
                // path.lineTo(event.offsetX + 120 / 2, 50)


                // this.canvasRendering2.fillStyle = "#33ffffff"
                // this.canvasRendering2.fill(path)


              }


            })
            .onActionEnd((event: GestureEvent) => {
              this.canvasRendering2.reset()
            })
        )
    }
  }
}