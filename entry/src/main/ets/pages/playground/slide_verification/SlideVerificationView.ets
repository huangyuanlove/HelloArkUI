import { hilog } from "@kit.PerformanceAnalysisKit"

@Component
export struct SlideVerificationView {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasRendering2: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State private canvasWidth: number = 0
  @State private canvasHeight: number = 0

  private path:Path2D = new Path2D()

  private imageData?: ImageData

  build() {
    Stack() {


      Canvas(this.canvasRendering).width("100%").height("100%").onReady(() => {
        this.canvasWidth = this.canvasRendering.width
        this.canvasHeight = this.canvasRendering.height
        let imageBitMap: ImageBitmap = new ImageBitmap("pages/playground/cat.webp")
        this.canvasRendering.drawImage(imageBitMap, 0, 0)
        this.imageData = this.canvasRendering.getImageData(50, 50, 120, 120)
        //在对应的区域绘制标识
        this.path.moveTo(110,50)
        this.path.lineTo(180,180)
        this.path.lineTo(50,180)
        this.path.lineTo(110,50)
        this.canvasRendering.lineWidth=2
        this.canvasRendering.strokeStyle = '#FFFFFF'
        this.canvasRendering.fillStyle = '#00FFFFFF'
        this.canvasRendering.shadowBlur = 800
        this.canvasRendering.shadowColor = '#00FFFFFF'
        // this.canvasRendering.shadowOffsetX =-10
        // this.canvasRendering.shadowOffsetY  = -10
        this.canvasRendering.stroke(this.path)


      })
      Canvas(this.canvasRendering2).width("100%").height("100%").onReady(()=>{
        this.canvasRendering2.fillStyle="#88e7e7e7"
        // this.canvasRendering2.fillRect(0,0,this.canvasWidth,this.canvasHeight)
      })
        .priorityGesture(
          PanGesture()
            .onActionStart((event: GestureEvent) => {

            })
            .onActionUpdate((event: GestureEvent) => {
              hilog.error(0x01,'SlideVerificationView', event.offsetX.toString())


              if(this.imageData){

                this.canvasRendering2.reset()
                let imageWidth = px2vp(this.imageData.width)
                let imageHeight = px2vp(this.imageData.height)
                let width = this.imageData.width
                let height = this.imageData.height
                let rate = height/width
                for(let i =0;i<this.imageData.data.length;i++){

                }
                this.canvasRendering2.putImageData(this.imageData, event.offsetX, 50)


                let path:Path2D = new Path2D()
                path.moveTo(event.offsetX + imageWidth/2,50)
                path.lineTo(event.offsetX + imageWidth,50 +imageHeight)
                path.lineTo(event.offsetX ,50 + imageHeight)
                path.lineTo(event.offsetX + imageWidth/2,50)


                this.canvasRendering2.fillStyle = "#11ffffff"
                this.canvasRendering2.fill(path)
                this.canvasRendering2.globalCompositeOperation = 'source-out'


              }


            })
            .onActionEnd((event: GestureEvent) => {
              this.canvasRendering2.reset()
            })
        )
    }
  }
}