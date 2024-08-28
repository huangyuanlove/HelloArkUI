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
      hilog.error(0x01, "draw", `${this.startNumber}  ${endY}`)
      if (this.startNumber % 10 == 0) {
        this.canvasRendering.lineTo(currentX, endY + 10)
        this.canvasRendering.stroke()
      }

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
          this.canvasRendering.strokeStyle = "#ff6134"
          this.canvasRendering.fillStyle = "#ff6134"
          this.canvasRendering.font = "36px sans-serif"
          this.canvasRendering.lineWidth = this.lineWidth
          this.draw()

        })
          .gesture(PanGesture().onActionStart((event: GestureEvent) => {
            hilog.error(0x01, "RulerPage", "'Pan start")
          })
            .onActionUpdate((event: GestureEvent) => {
              if (event) {
                // hilog.error(0x01,"RulerPage",`Pan update  ${event.offsetX}  ${event.offsetY}`)
                if (this.baseNumber == 0 && event.offsetX > 0) {
                  //刻度尺显示0之后不能向右拖动
                  hilog.error(0x01, "RulerPage", "刻度尺显示0之后不能向右拖动")
                } else {
                  this.baseNumber -= Math.floor(event.offsetX / 200)
                  hilog.error(0x01, "RulerPage", `拖动后重绘  ${this.baseNumber}`)
                  this.draw()
                }
              }
            })
            .onActionEnd((event: GestureEvent) => {
              hilog.error(0x01, "RulerPage", `Pan end  ${event.offsetX}  ${event.offsetY}`)
              console.info('Pan end')
            }))


      Row() {
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
          this.draw()
        })
        Button("清空画布").onClick((_) => {
          this.canvasRendering.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
        })

      }

    }
  }
}