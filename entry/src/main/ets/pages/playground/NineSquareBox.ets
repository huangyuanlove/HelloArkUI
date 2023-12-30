import image from '@ohos.multimedia.image'

@Component
@Entry
struct NineSquareBox {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasWidth: number = 0
  private canvasHeight: number = 0
  private dividerWidth: number = 10

  private imageBitMap:ImageBitmap = new ImageBitmap("pages/playground/cat.webp")



  build() {

    Canvas(this.canvasRendering) {
    }
    .onAreaChange((oldValue, newValue) => {
      this.canvasWidth = parseInt(newValue.width.toString())
      this.canvasHeight = parseInt(newValue.height.toString())

      let imageBitMap: ImageBitmap = new ImageBitmap("pages/playground/cat.webp")

      this.canvasRendering.drawImage(imageBitMap, 0, 0)

      //均分为三段，
      let perWidth = this.canvasWidth / 3
      this.canvasRendering.lineWidth = this.dividerWidth
      this.canvasRendering.lineCap = "square"
      this.canvasRendering.fillStyle = "#ff6134"
      //第一条竖线
      this.canvasRendering.moveTo(perWidth - this.dividerWidth / 2, 0)
      this.canvasRendering.lineTo(perWidth - this.dividerWidth / 2, this.canvasHeight)
      //第二条竖线
      this.canvasRendering.moveTo(perWidth * 2 - this.dividerWidth / 2, 0)
      this.canvasRendering.lineTo(perWidth * 2 - this.dividerWidth / 2, this.canvasHeight)


      let perHeight = this.canvasHeight / 3
      //第一条横线
      this.canvasRendering.moveTo(0, perHeight - this.dividerWidth / 2)
      this.canvasRendering.lineTo(this.canvasWidth, perHeight - this.dividerWidth / 2)
      //第二条横线
      this.canvasRendering.moveTo(0, perHeight * 2 - this.dividerWidth / 2)
      this.canvasRendering.lineTo(this.canvasWidth, perHeight * 2 - this.dividerWidth / 2)
      this.canvasRendering.stroke()


    }).width(this.imageBitMap.width).height(this.imageBitMap.height)

  }
}