import matrix4 from '@ohos.matrix4'
import { ActionBar } from '../../comm/ActionBar';
import { CanvasBallAnimation } from './CanvasBallAnimation'

@Preview
@Entry
@Component
struct AnimationOfSphericalPaths {
  @State angleX: number = 0
  @State translateX: number = 0
  @State translateY: number = 0
  @State translateZ: number = 0
  @State ballRadius: number = 30
  private timerInterval: number = 0
  private radius = 200
  private a = 90
  private b = 0


  toRadians(degrees:number): number {
    return degrees * (Math.PI / 180)
  }

  changeAngleX() {
    this.b += 3
    // this.a += 3
    if (this.a > 360) {
      this.a = this.a - 360
    }
    if (this.b > 360) {
      this.b = this.b - 360
    }

    this.translateX = this.radius * Math.cos(this.toRadians(this.a)) * Math.sin(this.toRadians(this.b)) * 2
    this.translateY = this.radius * Math.sin(this.toRadians(this.a)) * Math.sin(this.toRadians(this.b)) * 2
    this.translateZ = this.radius * Math.cos(this.toRadians(this.b)) * 2

    this.ballRadius = this.translateZ / this.radius * 10 + 50

    console.error(`translateX-> ${this.translateX} ,translateY-> ${this.translateY} ,translateZ-> ${this.translateZ}`)

  }

  build() {
    Column() {

      ActionBar({title:"球面动画"})

      Stack() {
        Circle({ width: this.radius * 2, height: this.radius * 2 }).fill(Color.Yellow)
        Circle({ width: this.ballRadius, height: this.ballRadius }).fill(Color.Pink)
          .transform(matrix4.identity().translate({ x: this.translateX, y: this.translateY, z: this.translateZ }))
      }.alignContent(Alignment.Center).width(this.radius * 2).height(this.radius * 2)

      Row() {
        Button("start")
          .onClick(() => {
            if (this.timerInterval > 0) {
              return
            }

            this.timerInterval = setInterval(()=>{

              this.changeAngleX()

            }, 20)
          })
        Button("stop").onClick(() => {
          clearInterval(this.timerInterval)
          this.timerInterval = 0
        }).margin({ left: 48 })
      }.margin({ top: 48 })

      CanvasBallAnimation()

    }.width("100%").height("100%").backgroundColor(Color.White)
  }

}