import image from '@ohos.multimedia.image'
import ActionBar from '../../comm/ActionBar'

@Entry
@Component
export struct Image3D {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private imageBitMap: ImageBitmap = new ImageBitmap("pages/playground/cat.webp")
  context = getContext(this)
  private preX: number = 0
  private preY: number = 0
  private canvasWidth = 0
  private canvasHeight = 0


  build() {
    Column() {
      ActionBar({ title: "3D卡片" })
      Canvas(this.canvasRendering).backgroundColor(Color.Orange)
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.canvasWidth = parseInt(newValue.width.toString())
          this.canvasHeight = parseInt(newValue.height.toString())

        })
        .onReady(() => {
          let imageWidth = this.imageBitMap.width
          let imageHeight = this.imageBitMap.height
          this.canvasRendering.translate((this.canvasWidth - imageWidth)/2,(this.canvasHeight-imageHeight)/2)

          // this.canvasRendering.drawImage(this.imageBitMap, (this.canvasWidth - imageWidth)/2, (this.canvasHeight-imageHeight)/2)
          this.canvasRendering.drawImage(this.imageBitMap, 0,0)

        }).onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {

          this.preX = event.touches[0].x
          this.preY = event.touches[0].y
        }
        if (event.type === TouchType.Move) {
          let diffX = event.touches[0].x - this.preX
          let diffY = event.touches[0].y - this.preY



          this.preX = event.touches[0].x
          this.preY = event.touches[0].y

        }
      })
    }.height("100%").width("100%").padding({ top: 48 })
  }
}