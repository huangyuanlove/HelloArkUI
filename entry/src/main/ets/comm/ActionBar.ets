
import router from '@ohos.router'
import { Level } from '@ohos/hypium'
@Preview
@Component
export default struct  ActionBar{
  @Prop title:string

  build(){
    Row(){
      Image($r("app.media.action_bar_go_back"))
        .margin({left:10})
        .width(32)
        .height(32)
        .onClick(()=>{
        router.back()
      })

        Text(this.title?this.title:router.getState().name ).layoutWeight(1).margin({right:32}).textAlign(TextAlign.Center).fontSize(24).fontColor(Color.Black)

    }.alignItems(VerticalAlign.Center).padding({top:48,bottom:16}).shadow({radius:1}).width('100%')
  }

}