import ActionBar from '../../comm/ActionBar'

@Preview
@Entry
@Component
struct Image3D {
  @State angle: number = 10
  private preX: number = 0
  private preY: number = 0
  @State x: number = 0
  @State y: number = 0
  @State z: number = 0

  build() {
    Column() {
      ActionBar({ title: "3D卡片" })

      Image($r("app.media.cat")).width("100%").height("40%")
        .rotate({
          x: this.x,
          y: this.y,
          z: this.z,
          centerX: '50%',
          centerY: '50%',
          angle: this.angle
        })


        .onTouch((value: TouchEvent) => {
          if (value.type == TouchType.Move) {
            let x = value.touches[0].x
            let y = value.touches[0].y

            let diffX = x - this.preX
            let diffY = y - this.preY
            if (diffX > diffY) {
              this.x = 1
              this.y = 0
            } else {
              this.y = 1
              this.x = 0
            }
            this.angle += diffX/10
            this.preX = x
            this.preY = y

          }
        })

    }.height("100%").width("100%")

  }
}