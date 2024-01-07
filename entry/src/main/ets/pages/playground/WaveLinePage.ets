import hilog from '@ohos.hilog'
@Entry
@Component
struct WaveLinePage {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasHeight: number = -1
  private canvasWidth: number = -1
 @State private dx:number = 400//最大值等于 waveWidth
  private waveHeight = 100
  private baseHeight = 300
  private waveWidth = 0;

  startAnimation(){

  }


  drawWave(){
    this.dx += 50
    if(this.dx >=this.canvasWidth){
      this.dx = 0
    }
    console.error(`偏差-->  ${this.dx}` )
    this.canvasRendering.clearRect(0,0,this.canvasWidth,this.canvasHeight)

    let path:Path2D = new Path2D()
    //从屏幕之外开始画
    path.moveTo(-this.canvasWidth +this.dx,this.baseHeight)

    path.quadraticCurveTo(-this.canvasWidth/2 +this.dx,this.baseHeight-this.waveHeight  ,0+this.dx,this.baseHeight)
    path.quadraticCurveTo(this.canvasWidth/2 + this.dx,this.baseHeight - this.waveHeight,this.canvasWidth +this.dx,this.baseHeight)
    this.canvasRendering.fillStyle = "#39d160"
    this.canvasRendering.fill(path)
    this.canvasRendering.fillRect(0,this.baseHeight,this.canvasWidth,this.canvasHeight-this.baseHeight)

  }

  build() {
    Column() {
      Canvas(this.canvasRendering).layoutWeight(1).width("100%")
        .onAreaChange((oldValue, newValue) => {
          this.canvasWidth = parseInt(newValue.width.toString())
          this.canvasHeight = parseInt(newValue.height.toString())

          this.baseHeight = this.canvasHeight-300
          this.waveWidth = this.canvasWidth/1.5
          this. drawWave()

        })
      Button("开始").onClick(()=>{
        setInterval(function(){
          this.drawWave()
        }.bind(this), 100)
      })
    }
  }
}