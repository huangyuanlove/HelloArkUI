@Component
@Preview
export struct ClockView {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State private hour: number = 0
  @State private minute: number = 0
  @State private second: number = 0


  let

  aboutToAppear() {
    let date: Date = new Date()
    this.hour = date.getHours()
    this.minute = date.getMinutes()
    this.second = date.getSeconds()
  }

  private  draw(centerX:number,centerY:number,){
    // Clockwise
    // minute hand
    // Seconds hand

    //计算秒针的角度
    let secondDegree= Math.PI * 2/60 * this.second
    let secondStartX


  }

  build() {
    Canvas(this.canvasRendering).width("100%").height("100%").onReady(() => {
      //计算中间点
      let width = this.canvasRendering.width
      let height = this.canvasRendering.height

      let centerX = width / 2
      let centerY = height / 2
      let maxRadius = (centerX > centerY ? centerY : centerX)-20

      this.canvasRendering.arc(maxRadius+20, maxRadius+20, 10, 0, Math.PI * 2, false)
      this.canvasRendering.stroke()
      this.canvasRendering.beginPath()
      this.canvasRendering.arc(maxRadius+20, maxRadius+20, maxRadius, 0, Math.PI * 2, false);
      this.canvasRendering.strokeStyle = "#1b91e0"
      this.canvasRendering.stroke()
      this.canvasRendering.font = "40px"
      //画 1~12 数字圆形分布
      let perNumberDegree = Math.PI * 2 / 12
      let numberRadius = maxRadius + 10

      for (let i = 1;i <= 12; i++) {
        let x = maxRadius + Math.sin(i * perNumberDegree ) * numberRadius+15
        let y = maxRadius + Math.cos(i * perNumberDegree+ Math.PI) * numberRadius +25

        this.canvasRendering.fillText(i + "", x,y)
      }

      //画内圈
      this.canvasRendering.beginPath()
      let innerRadius = maxRadius-20
      this.canvasRendering.arc(maxRadius+20, maxRadius+20, innerRadius, 0, Math.PI * 2, false)
      this.canvasRendering.stroke()

      //画 60 个格子，5 的倍数则线条粗一些
      let perMinuteDegree = Math.PI * 2 / 60
      for(let i =1 ;i <=60;i++){

        let endX = maxRadius + Math.sin(i * perMinuteDegree ) * maxRadius+20
        let endY = maxRadius + Math.cos(i * perMinuteDegree+ Math.PI) * maxRadius + 20

        let startX = maxRadius + Math.sin(i * perMinuteDegree ) * innerRadius+20
        let startY = maxRadius + Math.cos(i * perMinuteDegree+ Math.PI) * innerRadius+20

        this.canvasRendering.strokeStyle = "#000000"

        let path2D = new Path2D()
        path2D.moveTo(startX,startY)
        path2D.lineTo(endX,endY)
        if(i % 5 ==0){
          this.canvasRendering.lineWidth =  6
        }else{
          this.canvasRendering.lineWidth =  2
        }
        this.canvasRendering.stroke(path2D)




      }

    })
  }
}