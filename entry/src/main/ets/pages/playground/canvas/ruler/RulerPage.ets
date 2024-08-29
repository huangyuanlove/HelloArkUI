import { hilog } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct RulerPage {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private minLineHeight = 10
  private midLineHeight = 20
  private maxLineHeight = 30
  private lineWidth = 5
  private startNumber = 0
  private spacing = 10
  private  baseNumber: number = 123
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right })
  private canvasWidth: number = 0
  private canvasHeight: number = 0
  private timer: number = -1

  @State panGestureX:number =0
  @State panGestureY:number =0


  draw() {
    this.canvasRendering.clearRect(0, 0, this.canvasWidth, this.canvasHeight)

    this.startNumber = this.baseNumber
    let currentX = 0
    while (currentX <= this.canvasWidth) {
      //当前竖线的起点x坐标
      currentX = this.lineWidth / 2 + (this.startNumber - this.baseNumber) * (this.lineWidth + this.spacing)
      this.canvasRendering.moveTo(currentX, 10)
      //当前竖线的终点点x坐标
      let endY = this.minLineHeight
      if (this.startNumber % 10 == 0) {
        endY = this.maxLineHeight
        this.canvasRendering.fillText((this.startNumber / 10).toString(), currentX - this.lineWidth / 2, endY + 24)
      } else if (this.startNumber % 5 == 0) {
        endY = this.midLineHeight
      }

      // if (this.startNumber % 10 == 0) {
        let hourPath = new Path2D()

        hourPath.moveTo(currentX, 10)
        hourPath.lineTo(currentX, endY + 10)
        this.canvasRendering.stroke(hourPath)
        // this.canvasRendering.lineTo(currentX, endY + 10)
        // this.canvasRendering.stroke()
      // }

      this.startNumber++
    }
  }

  build() {
    Column() {

        Canvas(this.canvasRendering).width("100%").height("80%").onReady(() => {
          hilog.error(0x01, "draw", `onReady`)
          this.canvasWidth = this.canvasRendering.width
          this.canvasHeight = this.canvasRendering.height
          this.canvasRendering.lineCap = "round"
          this.canvasRendering.strokeStyle = "#aaff6134"
          this.canvasRendering.fillStyle = "#aaff6134"
          this.canvasRendering.font = "36px sans-serif"
          this.canvasRendering.lineWidth = this.lineWidth
          this.draw()

        })

          .gesture(PanGesture(this.panOption).onActionStart((event: GestureEvent) => {
            hilog.error(0x01, "RulerPage", "'Pan start")
            this.panGestureX =  event.offsetX
          })
            .onActionUpdate((event: GestureEvent) => {
              if (event) {
                hilog.error(0x01,"RulerPage",`Pan update  ${event.offsetX} `)
                let diff = this.panGestureX-event.offsetX
                hilog.error(0x01,"RulerPage",`Pan update diff-> ${diff} `)
                this.panGestureX = event.offsetX

                if (this.baseNumber == 0 && event.offsetX > 0) {
                  //刻度尺显示0之后不能向右拖动
                  hilog.error(0x01, "RulerPage", "刻度尺显示0之后不能向右拖动")
                } else {
                  let result = this.baseNumber + (diff/15)
                  this.baseNumber = Math.round(result)
                  // this.baseNumber -= Math.floor(event.offsetX / 200)
                  // hilog.error(0x01, "RulerPage", `拖动后重绘  ${this.baseNumber}`)
                  this.draw()
                }
              }
            })
            .onActionEnd((event: GestureEvent) => {
              hilog.error(0x01, "RulerPage", `Pan end  ${event.offsetX} `)
              console.info('Pan end')
            }))


      Flex({wrap:FlexWrap.Wrap}) {
        Button("开始").onClick((_) => {
          if(this.timer == -1){
            this.timer = setInterval(() => {
              this.baseNumber += 1
              this.draw()
            }, 1000)
          }

        })
        Button("暂停").onClick((_) => {
          if (this.timer != -1) {
            clearInterval(this.timer)
            this.timer = -1
          }
        })
        Button("手动加1").onClick((_) => {
          this.baseNumber += 1
          this.canvasRendering.strokeStyle = "#aa1b91e0"
          this.canvasRendering.fillStyle = "#aa1b91e0"
          this.canvasRendering.font = "36px sans-serif"
        })
        Button("绘制").onClick((_) => {
          this.draw()
        })
        Button("重置").onClick((_) => {
          this.canvasRendering.reset()
        })
        Button("清空画布").onClick((_) => {
          this.canvasRendering.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
        })
        Button("stroke").onClick((_) => {
          this.canvasRendering.stroke()
        })
        Text(`PanGestureX:${this.panGestureX}`)

      }

    }
  }
}