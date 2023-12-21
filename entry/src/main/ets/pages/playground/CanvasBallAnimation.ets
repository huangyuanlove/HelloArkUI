@Preview
@Component
export struct CanvasBallAnimation {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasWidth = 0
  private canvasHeight = 0
  @State canvasBallX: number = 0
  @State canvasBallY: number = 0
  @State canvasBallZ: number = 0
  @State canvasBallRadius: number = 30
  @State canvasBallRoundRadius: number = 0
  private canvasBallAnimationTimer: number = 0
  private xr: number = this.toRadians(5)
  private yr: number = 0
  private zr: number = 0
  private pointList: Point[] = []

  toRadians(degrees): number {
    return degrees * (Math.PI / 180)
  }

  canvasBallAnimation() {


    this.canvasBallX = this.canvasBallRoundRadius * Math.cos(this.toRadians(this.a)) * Math.sin(this.toRadians(this.b))
    this.canvasBallY = this.canvasBallRoundRadius * Math.sin(this.toRadians(this.a)) * Math.sin(this.toRadians(this.b))
    this.canvasBallZ = this.canvasBallRoundRadius * Math.cos(this.toRadians(this.b))

    this.canvasBallRadius = this.canvasBallZ / this.canvasBallRoundRadius * 10 + 50

    this.canvasRendering.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
    this.canvasRendering.beginPath()
    let ballPath2D: Path2D = new Path2D()
    ballPath2D.arc(this.canvasBallX, this.canvasBallY, this.canvasBallRadius, 0, Math.PI * 2)
    this.canvasRendering.fill(ballPath2D)


  }

  build() {
    Column() {


      Canvas(this.canvasRendering)
        .width("100%")
        .height("40%")
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.canvasWidth = parseInt(newValue.width.toString())
          this.canvasHeight = parseInt(newValue.height.toString())

          //小球运动的半径
          this.canvasBallRoundRadius = Math.min(this.canvasWidth, this.canvasHeight) / 3
          this.canvasRendering.translate(this.canvasWidth / 2, this.canvasHeight / 2)
          if (!this.pointList && this.pointList.length == 0) {
            let maxBallCount = 1
            this.pointList = []
            for (let i = 0; i < maxBallCount; i++) {

              let v = -1.0 + (2.0 * i - 1.0) / maxBallCount;
              if (v < -1.0) {
                v = 1.0
              }

              let delta = Math.acos(v)
              let alpha = Math.sqrt( maxBallCount * Math.PI ) * delta
              let point = new Point()
              point.x = this.canvasBallRoundRadius * Math.cos(alpha) * Math.sin(delta)
              point.y = this.canvasBallRoundRadius * Math.sin(alpha) * Math.sin(delta)
              point.z = this.canvasBallRoundRadius * Math.cos(delta)
              point.color = 0x1b91e0
              this.pointList.push(point)
            }
          }


          // this.canvasRendering.beginPath()
          // let ballPath2D: Path2D = new Path2D()
          // ballPath2D.arc(this.canvasBallX, this.canvasBallY, this.canvasBallRadius, 0, Math.PI * 2)
          // this.canvasRendering.fill(ballPath2D)
        })
      Row() {
        Button("canvas ball start").onClick(() => {
          if (this.canvasBallAnimationTimer > 0) {
            return
          }
          this.canvasBallAnimationTimer = setInterval(function(){
            this.canvasBallAnimation()
          }.bind(this), 20)
        })
        Button("canvas ball end").onClick(() => {
          clearInterval(this.canvasBallAnimationTimer)
          this.canvasBallAnimationTimer = 0
        })
      }
    }
  }
}

class Point {
  color: number
  x: number
  y: number
  z: number
}