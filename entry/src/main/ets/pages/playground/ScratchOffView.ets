import hilog from '@ohos.hilog'

@Preview
@Component
export struct ScratchOffView {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private path: Path2D = new Path2D()

  build() {
    Stack() {
      Image($r("app.media.cat"))
      Canvas(this.canvasRendering).width("100%").height("100%").onReady(() => {
        let canvasWidth = this.canvasRendering.width
        let canvasHeight = this.canvasRendering.height
        hilog.error(0x000, "ScratchOffView", `onReady :canvasWidth--> ${canvasWidth}, canvasHeight--> ${canvasHeight}`)

        this.canvasRendering.fillStyle = "#aaf7f7f7"
        this.canvasRendering.fillRect(0, 0, canvasWidth, canvasHeight)


        this.canvasRendering.strokeStyle = "#00000000"
        this.canvasRendering.fillStyle = "#000000"
        this.canvasRendering.globalCompositeOperation = "destination-out"


      }).onTouch((event: TouchEvent) => {

        let path = new Path2D()
        let prex = 0
        let prey = 0
        switch (event.type) {
          case TouchType.Down:
            prex = event.touches[0].x
            prey = event.touches[0].y
            path.moveTo(prex, prey)
            break
          case TouchType.Move:
            this.path.moveTo(event.touches[0].x, event.touches[0].y)
            this.path.arc(event.touches[0].x, event.touches[0].y, 30, 0, Math.PI*2, false)
            this.canvasRendering.fill(this.path)


            break
          case TouchType.Up:
            break;
        }
      })
    }.width("100%").height("100%")

  }
}