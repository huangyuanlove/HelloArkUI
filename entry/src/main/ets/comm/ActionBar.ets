
import router from '@ohos.router'
import deviceInfo from '@ohos.deviceInfo'
@Preview
@Component
export default struct  ActionBar{
  @Prop title:string

  private topPadding:number = 16


  aboutToAppear(){
    if(deviceInfo.deviceType == "tablet"){
      this.topPadding = 48
    }

    if(!this.title){
      this.title = router.getState().path
    }
  }

  build(){
    Row(){
      Image($r("app.media.action_bar_go_back"))
        .margin({left:10})
        .width(32)
        .height(32)
        .onClick(()=>{
        router.back()
      })

        Text(this.title ).layoutWeight(1).margin({right:32}).textAlign(TextAlign.Center).fontSize(24).fontColor(Color.Black)
      Image($r("app.media.source_code"))
        .margin({right:10})
        .width(32)
        .height(32)
        .onClick(()=>{
          router.pushUrl({url:"WebViewPage",params:{path:"", }})
        })
    }.alignItems(VerticalAlign.Center).padding({top:this.topPadding,bottom:16}).shadow({radius:1}).width('100%')
  }

}