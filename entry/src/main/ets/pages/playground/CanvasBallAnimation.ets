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
  private startDegree: number = 5
  private xr: number = this.toRadians(this.startDegree)
  private yr: number = 0
  private zr: number = 0
  private pointList: Point[] = []

  toRadians(degrees): number {
    return degrees * (Math.PI / 180)
  }

  canvasBallAnimation() {
    this.startDegree += 5;
    if (this.startDegree > 360) {
      this.startDegree -= 360
    }

    this.canvasRendering.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
    this.calculateRotateValue()
    //排序，先画背面的，再画正面的
    this.pointList.sort(this.comparator)
    this.drawFrontBall()

    //在中间画一个大圆
    this.drawCenterBall()
    this.drawBackBall()


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
          // this.canvasRendering.translate(this.canvasWidth / 2, this.canvasHeight / 2)
          this.generateBall()
          this.calculateRotateValue()
          //排序，先画背面的，再画正面的
          this.pointList.sort(this.comparator)
          this.drawFrontBall()

          //在中间画一个大圆
         this.drawCenterBall()

          this.drawBackBall()


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

  comparator(left: Point, right: Point): number {
    if (left.z - right.z < 0) {
      return 1;
    }
    if (left.z == right.z) {
      return 0;
    }
    return -1;

  }

  randomColor(): string {
    let r: string = Math.floor(Math.random() * 256).toString(16)
    let g: string = Math.floor(Math.random() * 256).toString(16)
    let b: string = Math.floor(Math.random() * 256).toString(16)
    let result = `${r}${g}${b}`
    console.error(`随机颜色--> ${result}`)
    return result
  }

  generateBall() {
    if (this.pointList.length == 0) {
      let maxBallCount = 10
      this.pointList = []
      for (let i = 0; i < maxBallCount; i++) {

        let v = -1.0 + (2.0 * i - 1.0) / maxBallCount;
        if (v < -1.0) {
          v = 1.0
        }

        let delta = Math.acos(v)
        let alpha = Math.sqrt(maxBallCount * Math.PI) * delta
        let point = new Point()
        point.x = this.canvasBallRoundRadius * Math.cos(alpha) * Math.sin(delta)
        point.y = this.canvasBallRoundRadius * Math.sin(alpha) * Math.sin(delta)
        point.z = this.canvasBallRoundRadius * Math.cos(delta)
        point.color = this.randomColor()
        this.pointList.push(point)
      }
    }
  }

  calculateRotateValue() {
    for (let i = 0; i < this.pointList.length; i++) {

      let point = this.pointList[i];
      let x = point.x;
      let y = point.y;
      let z = point.z;

      //绕X轴旋转，乘以X轴的旋转矩阵
      let rx1 = x;
      let ry1 = (y * Math.cos(this.xr) + z * -Math.sin(this.xr));
      let rz1 = (y * Math.sin(this.xr) + z * Math.cos(this.xr));

      // 绕Y轴旋转,乘以Y轴的旋转矩阵
      let rx2 = (rx1 * Math.cos(this.yr) + rz1 * Math.sin(this.yr));
      let ry2 = ry1;
      let rz2 = (rx1 * -Math.sin(this.yr) + rz1 * Math.cos(this.yr));

      // 绕Z轴旋转,乘以Z轴的旋转矩阵
      let rx3 = (rx2 * Math.cos(this.zr) + ry2 * -Math.sin(this.zr));
      let ry3 = (rx2 * Math.sin(this.zr) + ry2 * Math.cos(this.zr));
      let rz3 = rz2;


      point.x = rx3;
      point.y = ry3;
      point.z = rz3;

      // 透视除法，z轴向内的方向
      let scale = (2 * this.canvasBallRoundRadius) / ((2 * this.canvasBallRoundRadius) + rz3);
      point.scale = scale;
    }
  }

  drawFrontBall() {
    for (let i = 0; i < this.pointList.length; i++) {
      let point = this.pointList[i];
      if (point.z > 0) {
        this.drawBall(point)
      } else {
        break;
      }
    }
  }

  drawBall(point: Point) {
    if (point.scale > 1) {
      this.canvasRendering.fillStyle = `#FF${point.color}`
    } else {
      let fillColor = `#${ Math.round(point.scale * 255).toString(16)}${point.color}`
      this.canvasRendering.fillStyle = fillColor
      console.error("填充颜色-->" +fillColor)
    }

    let ballPath2D = new Path2D()
    ballPath2D.arc(point.x * point.scale +this.canvasWidth / 2 , point.y * point.scale + this.canvasHeight / 2, 5 + 25 * point.scale, 0, Math.PI * 2)
    this.canvasRendering.beginPath()
    this.canvasRendering.fill(ballPath2D)
  }

  drawBackBall() {
    for (let i = this.pointList.length - 1; i >= 0; i--) {
      let point = this.pointList[i];
      if (point.z <= 0) {
        this.drawBall(point)
      } else {
        break;
      }
    }
  }
  drawCenterBall(){
    let circlePath2D = new Path2D()
    circlePath2D.arc(this.canvasWidth/2,this.canvasHeight/2,this.canvasBallRoundRadius,0,Math.PI * 2)
    this.canvasRendering.beginPath()

    let radialGradient = this.canvasRendering.createRadialGradient(this.canvasWidth/2,this.canvasHeight/2,0,this.canvasWidth/2,this.canvasHeight/2,this.canvasBallRoundRadius)
    radialGradient.addColorStop(0.0,"#ff0000")
    radialGradient.addColorStop(0.3,"#aaec5533")
    radialGradient.addColorStop(0.9,"#11000000")
    this.canvasRendering.fillStyle=radialGradient
    this.canvasRendering.fill(circlePath2D)
  }
}


class Point {
  color: string
  x: number
  y: number
  z: number
  scale: number = 1
}