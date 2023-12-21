import matrix4 from '@ohos.matrix4'
import ActionBar from '../../comm/ActionBar'

@Preview
@Entry
@Component
struct Image3D {
  @State angleX: number = 0
  @State angleY: number = 0
  private preX: number = 0
  private preY: number = 0
  @State x: number = 1
  @State y: number = 1

  build() {
    Column() {
      ActionBar({ title: "3D卡片" })

      Image($r("app.media.cat")).width("100%").height("40%")

        .transform(
          matrix4.identity().rotate({ x: this.x, angle: this.angleX })
          .combine(matrix4.identity().rotate({ y: this.y, angle: this.angleY })

          )
        )


        .onTouch((value: TouchEvent) => {
          let x = value.touches[0].x
          let y = value.touches[0].y

          if (value.type == TouchType.Down) {
            this.preX = x
            this.preY = y
          } else if (value.type == TouchType.Move) {
            let diffX = x - this.preX
            let diffY = y - this.preY
            if (Math.abs(diffX) > Math.abs(diffY)) {
              this.angleY += diffX / 2
            } else {
              this.angleX += diffY / 2
            }


            this.preX = x
            this.preY = y

          }
        })

    }.height("100%").width("100%")

  }
}