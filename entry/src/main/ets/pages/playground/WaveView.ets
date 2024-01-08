@Preview
@Component
export struct WaveView{
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasHeight: number = -1
  private canvasWidth: number = -1
  @State private dx: number = 0 //最大值等于 waveWidth
  private waveHeight = 50
  private baseHeight = 300
  private waveWidth = 0;
  private intervalTimer: number = 0
  drawWave() {
    this.dx += 4
    if (this.dx >= this.waveWidth) {
      this.dx = 0
    }
    console.error(`偏差-->  ${this.dx}`)
    this.canvasRendering.clearRect(0, 0, this.canvasWidth, this.canvasHeight)

    if (this.waveWidth == 0) {
      this.waveWidth = this.canvasWidth / 2
    }

    let path: Path2D = new Path2D()
    path.moveTo(-this.waveWidth + this.dx, this.baseHeight)
    let startX = -this.waveWidth + this.dx
    while (startX < this.canvasWidth + this.dx) {

      let endY = this.baseHeight
      path.quadraticCurveTo(startX + this.waveWidth / 4, this.baseHeight - this.waveHeight, startX + this.waveWidth/2, endY)
      path.quadraticCurveTo(startX + this.waveWidth / 4*3, this.baseHeight + this.waveHeight, startX + this.waveWidth, endY)
      startX += this.waveWidth
    }
    path.lineTo(startX ,this.canvasHeight)
    path.lineTo(0 ,this.canvasHeight)
    path.lineTo(0 ,this.baseHeight + this.waveHeight)

    this.canvasRendering.fillStyle = "#39d167"
    this.canvasRendering.strokeStyle = "#39d167"
    this.canvasRendering.lineWidth = 10
    this.canvasRendering.fill(path)
    // this.canvasRendering.fillRect(0, this.baseHeight, this.canvasWidth, this.canvasHeight - this.baseHeight)

  }

  build() {
    Column() {
      Canvas(this.canvasRendering).layoutWeight(1).width("100%")
        .onAreaChange((oldValue, newValue) => {
          this.canvasWidth = parseInt(newValue.width.toString())
          this.canvasHeight = parseInt(newValue.height.toString())

          this.baseHeight = this.canvasHeight - 300
          this.waveWidth = this.canvasWidth / 2
          this.drawWave()

        })
      Row() {
        Button("开始").onClick(() => {
          if (this.intervalTimer != 0) {
            clearInterval(this.intervalTimer)
          }
          this.intervalTimer = setInterval(function(){
            this.drawWave()
          }.bind(this), 10)
        })
        Blank().width(15)
        Button("停止").onClick(() => {
          if (this.intervalTimer != 0) {
            clearInterval(this.intervalTimer)
          }
        })
      }.margin({ bottom: 10 })

    }
  }

}