import { ActionBar } from '../../comm/ActionBar';

@Entry
@Component
struct OrderProgressPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      ActionBar({ title: "订单进度条" })
      Column(){
        Row() {
          Text("09:10").fontColor("#1b91e0")
          Text("09:20").fontColor("#1b91e0")
          Text("09:30").fontColor("#1b91e0")
          Text("09:40")
        }.justifyContent(FlexAlign.SpaceBetween).width("100%")

        Stack() {
          Progress({ value: 75, type: ProgressType.Linear,total:100}).color("#1b91e0")
          Row() {
            Circle().fill("#1b91e0").strokeWidth(1).stroke(Color.White).width(18).height(18)
            Circle().fill("#1b91e0").strokeWidth(1).stroke(Color.White).width(18).height(18)
            Circle().fill("#1b91e0").strokeWidth(1).stroke(Color.White).width(18).height(18)
            Circle().fill("#999999").strokeWidth(1).stroke(Color.White)
          }.justifyContent(FlexAlign.SpaceBetween).width("100%")
        }.margin({top:10,bottom:10}).width("100%").alignContent(Alignment.Center)

        Row() {
          Text("接单").fontColor("#1b91e0")
          Text("就位").fontColor("#1b91e0")
          Text("取件").fontColor("#1b91e0")
          Text("送达")
        }.justifyContent(FlexAlign.SpaceBetween).width("100%")
      }.margin({top:20})

    }.padding({left:15,right:15})
    .height('100%')
    .width('100%')
  }
}