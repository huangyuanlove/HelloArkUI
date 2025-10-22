import { ActionBar } from '../../../comm/ActionBar';
import { ScrollDigitalComponent } from './ScrollDigitalComponent';

@Entry
@Component
struct AnimationPage {
  @State rotateAngle: number = 0
  @State leftNumber: number = 0
  @State rightNumber: number = 2
  @State rotateNumber: number = 1



  build() {
    Column() {
      ActionBar({ title: "组件动效" })
      Scroll() {
        Column() {

          Column(){
            Row() {
              Text(`${this.leftNumber}`)
                .fontSize(80)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .backgroundColor("#18183C")
                .width("35%")
                .height(100)
                .borderRadius(20)
                .rotate({
                  x: 0,
                  y: 1,
                  z: 0,
                  angle: '180deg',

                })
              Blank().width(20)

              Stack() {
                Text(`${this.rightNumber}`)
                  .fontSize(80)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .backgroundColor("#18183C")
                  .width("35%")
                  .height(100)
                  .borderRadius(20)
                Text(`${this.rotateNumber}`)
                  .fontSize(80)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .backgroundColor("#18183C")
                  .width("35%")
                  .height(100)
                  .borderRadius(20)
                  .rotate({
                    x: 0,
                    y: 1,
                    z: 0,
                    angle: `${this.rotateAngle}deg`,
                    centerX: -10,
                    centerY: "50%"
                  })
              }

            }
            Slider({ min: 0, max: 180, value: this.rotateAngle }).margin({ top: 20 }).onChange((value) => {
              if (value >= 180) {
                value -= 180
                if (!this.handled) {
                  this.handled = true
                  this.leftNumber += 1
                  this.rightNumber += 1
                  this.rotateNumber += 1
                }
              }
              this.rotateAngle = -value
            }).margin({ left: 15, right: 15 })
          }.backgroundColor("#b45e33").margin({left:15,right:15}).borderRadius(12).padding(15)


          Column(){
              ScrollDigitalComponent().height(26)


          }.margin(15).padding(15).backgroundColor("#0085ac").borderRadius(12)




        }.justifyContent(FlexAlign.Start)

      }.width("100%").height("100%")
    }
    .height('100%')
    .width('100%')
  }

  handled: boolean = false
}