
@Component
struct CompositeOperationView{
  @Prop compositeOperation:string
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  build() {
    Canvas(this.canvasRendering).width("100%").height("100%").onReady(() => {
      let canvasWidth = this.canvasRendering.width
      let canvasHeight = this.canvasRendering.height

      let circleX = canvasWidth/4
      let circleY = canvasHeight/4;
      let circleCenter = Math.min(circleX,circleY)

      this.canvasRendering.fillStyle = "#FF0000"
      this.canvasRendering.arc(circleCenter,circleCenter,circleCenter,0,Math.PI * 2, false)
      this.canvasRendering.fill()

      this.canvasRendering.globalCompositeOperation = this.compositeOperation

      this.canvasRendering.fillStyle = "#0000FF"
      this.canvasRendering.fillRect(circleCenter, circleCenter, circleCenter*2, circleCenter*2)

    })
  }
}

export{CompositeOperationView}


