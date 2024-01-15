@Preview
@Component
export struct ClockView {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasRenderingClock: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State private hour: number =0
  @State private minute: number =0
  @State private second: number =0
  private centerX: number = 0
  private centerY: number = 0
  private innerCircleRadius: number = 0

  private timer:number = -1

  aboutToDisappear(){
    if(this.timer > 0){
      clearInterval(this.timer)
    }
  }


  private draw() {


    // Clockwise
    // minute hand
    // Seconds hand
    this.canvasRenderingClock.clearRect(0,0,this.centerX * 2 ,this.centerY*2)

    //画秒针
    //计算秒针的角度
    let secondDegree = Math.PI * 2 / 60 * this.second
    let secondStartX = this.centerX
    let secondStartY = this.centerY
    let secondEndX = this.centerX + Math.sin(secondDegree) * this.innerCircleRadius
    let secondEndY = this.centerY + Math.cos(secondDegree + Math.PI) * this.innerCircleRadius
    let secondPath = new Path2D()
    secondPath.moveTo(secondStartX, secondStartY)
    secondPath.lineTo(secondEndX, secondEndY)
    this.canvasRenderingClock.lineWidth = 2
    this.canvasRenderingClock.stroke(secondPath)


    //画分针
    //秒针走一圈，分针走一格，其实可以忽略不计
    let minuteDegree = Math.PI * 2 / 60 * this.minute
    let minuteStartX = this.centerX
    let minuteStartY = this.centerY
    let minuteEndX = this.centerX + Math.sin(minuteDegree) * (this.innerCircleRadius / 5 * 4)
    let minuteEndY = this.centerY + Math.cos(minuteDegree + Math.PI) * (this.innerCircleRadius / 5 * 4)
    let minutePath = new Path2D()
    minutePath.moveTo(minuteStartX, minuteStartY)
    minutePath.lineTo(minuteEndX, minuteEndY)
    this.canvasRenderingClock.strokeStyle = "#aa1b91e0"
    this.canvasRenderingClock.lineWidth = 4
    this.canvasRenderingClock.stroke(minutePath)

    //画时针
    //分针走一圈，时针走 5 小格
    let hourDegree = Math.PI * 2 / 12 * this.hour + this.minute / 60 * Math.PI * 2 / 12
    let hourStartX = this.centerX
    let hourStartY = this.centerY
    let hourEndX = this.centerX + Math.sin(hourDegree) * (this.innerCircleRadius / 4 * 3)
    let hourEndY = this.centerY + Math.cos(hourDegree + Math.PI) * (this.innerCircleRadius / 4 * 3)
    let hourPath = new Path2D()
    hourPath.moveTo(hourStartX, hourStartY)
    hourPath.lineTo(hourEndX, hourEndY)
    this.canvasRenderingClock.lineWidth = 6
    this.canvasRenderingClock.strokeStyle = "#aa39d167"
    this.canvasRenderingClock.stroke(hourPath)


  }

  build() {

    Stack({ alignContent: Alignment.Center }) {
      Canvas(this.canvasRendering).width("100%").height("100%").onReady(() => {
        //计算中间点
        let width = this.canvasRendering.width
        let height = this.canvasRendering.height

        this.centerX = width / 2
        this.centerY = height / 2

        let maxLength = (this.centerX > this.centerY ? this.centerY : this.centerX)
        let outerCircleRadius = maxLength - 20

        //最中间的小圈圈
        this.canvasRendering.arc(this.centerX, this.centerY, 10, 0, Math.PI * 2, false)
        this.canvasRendering.stroke()


        //外圈
        this.canvasRendering.beginPath()
        this.canvasRendering.arc(this.centerX, this.centerY, outerCircleRadius, 0, Math.PI * 2, false);
        this.canvasRendering.strokeStyle = "#1b91e0"
        this.canvasRendering.stroke()

        //画 1~12 数字圆形分布
        this.canvasRendering.font = "40px"
        let perNumberDegree = Math.PI * 2 / 12
        let numberRadius = outerCircleRadius + 10

        for (let i = 1;i <= 12; i++) {
          let x = this.centerX + Math.sin(i * perNumberDegree) * numberRadius
          let y = this.centerY + Math.cos(i * perNumberDegree + Math.PI) * numberRadius

          this.canvasRendering.fillText(i + "", x, y)
        }

        //画内圈
        this.canvasRendering.beginPath()
        this.innerCircleRadius = outerCircleRadius - 20
        this.canvasRendering.arc(this.centerX, this.centerY, this.innerCircleRadius, 0, Math.PI * 2, false)
        this.canvasRendering.stroke()

        //画 60 个格子，5 的倍数则线条粗一些
        let perMinuteDegree = Math.PI * 2 / 60
        for (let i = 1;i <= 60; i++) {

          let endX = this.centerX + Math.sin(i * perMinuteDegree) * outerCircleRadius
          let endY = this.centerY + Math.cos(i * perMinuteDegree + Math.PI) * outerCircleRadius

          let startX = this.centerX + Math.sin(i * perMinuteDegree) * this.innerCircleRadius
          let startY = this.centerY + Math.cos(i * perMinuteDegree + Math.PI) * this.innerCircleRadius

          this.canvasRendering.strokeStyle = "#000000"

          let path2D = new Path2D()
          path2D.moveTo(startX, startY)
          path2D.lineTo(endX, endY)
          if (i % 5 == 0) {
            this.canvasRendering.lineWidth = 6
          } else {
            this.canvasRendering.lineWidth = 2
          }
          this.canvasRendering.stroke(path2D)

        }
        this.draw()
      })
      Canvas(this.canvasRenderingClock).width("100%").height("100%").onReady(()=>{
        this.timer = setInterval(function(){
          let date: Date = new Date()
          this.minute = date.getMinutes()
          this.hour = date.getHours()
          this.second = date.getSeconds()
          this.draw()
        }.bind(this),500)
      })
    }.width("100%").height("100%")
  }
}