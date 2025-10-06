const SEARCH_AREA_HEIGHT = 100
const ITEM_CARDS_AREA_HEIGHT = 200
const HORIZONTAL_LIST_HEIGHT = 100
const MIN_HORIZONTAL_LIST_SPACE:number = 10
const MAX_HORIZONTAL_LIST_SPACE:number = 50
class FakeHorizontalData{
  name:string
  icon:Resource

  constructor(name: string, icon: Resource) {
    this.name = name
    this.icon = icon
  }

}

@Entry
@Component
struct ComponentStackPage {
  outSideScrollController:Scroller = new Scroller()
  inSideScrollController:Scroller = new Scroller()

  @State searchAreaHeight:number = SEARCH_AREA_HEIGHT
  @State showHorizontalList:boolean = false

  @State itemCardsAreaOpacity:number = 1
  @State horizontalListOpacity:number = 0
  @State classifyAreaOpacity:number = 1
  @State horizontalListSpace:number= MAX_HORIZONTAL_LIST_SPACE



  @State fakeProduct:string[]=[]
  @State fakeHorizontalDataList:FakeHorizontalData[]=[]
  aboutToAppear(): void {
    for(let i =1;i<=20;i++){
      this.fakeProduct.push(`第 ${i} 项`)
    }
    this.fakeHorizontalDataList.push(new FakeHorizontalData("笔记本",$r('app.media.ic_device_matebook_filled')))
    this.fakeHorizontalDataList.push(new FakeHorizontalData("智慧屏",$r('app.media.ic_device_smartscreen_filled')))
    this.fakeHorizontalDataList.push(new FakeHorizontalData("音箱",$r('app.media.ic_device_sound_x_filled')))
    this.fakeHorizontalDataList.push(new FakeHorizontalData("VR眼镜",$r('app.media.ic_device_vr_glass_filled')))
    this.fakeHorizontalDataList.push(new FakeHorizontalData("手表",$r('app.media.ic_device_watch_filled')))
    this.fakeHorizontalDataList.push(new FakeHorizontalData("手机",$r('app.media.ic_public_devices_phone_filled')))
  }





  build() {
    Stack({alignContent:Alignment.Top}) {
      Row(){
        Image($r("app.media.user_portrait"))
          .width(30)
          .aspectRatio(1)
          .borderRadius(15)
        Blank().height(0)
        Image($r("app.media.stack_scan"))
          .width(30)
          .aspectRatio(1)

      }.width("100%").height(50).alignItems(VerticalAlign.Center).padding({left:15,right:15})

      Scroll(this.outSideScrollController){
        Column(){
          //搜索框
          Row() {
            Image($r('app.media.search'))
              .width(20)
              .aspectRatio(1)
              .margin({ left: 20 })

            Text('搜索提示语')
              .opacity(0.6)
              .fontColor(Color.Black)
              .fontColor(Color.Black)
              .fontSize(16)
              .margin({ left: 10 })
          }
          .height(this.searchAreaHeight)
          .backgroundColor(Color.White)
          .width("100%")
          .borderRadius(12)
          .onClick((_) => {
            this.getUIContext().getPromptAction().showToast({ message: "跳转到搜索页面" })
          })
          Stack({alignContent:Alignment.Top}){
            if(this.showHorizontalList){
              Scroll(){
                Row({space:this.horizontalListSpace}){
                  ForEach(this.fakeHorizontalDataList,(item:FakeHorizontalData,index:number)=>{
                    Column(){
                      Image(item.icon).width(40).aspectRatio(1)
                        .objectFit(ImageFit.Contain)
                      Blank().width(15).height(0)
                      Text(item.name).fontSize(16)
                    }.width(80).backgroundColor(Color.White).borderRadius(10).height(90).justifyContent(FlexAlign.Center)
                  })
                }.justifyContent(FlexAlign.Center)
              }.scrollable(ScrollDirection.Horizontal).zIndex(1).height(HORIZONTAL_LIST_HEIGHT).width("100%").opacity(this.horizontalListOpacity).backgroundColor("#f1f1f1")

            }else{
              Column(){
                Row(){
                  Row(){
                    Text("笔记本").fontSize(16)
                    Blank().width(15).height(0)
                    Image($r('app.media.ic_device_matebook_filled')).width(50).aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                  }.layoutWeight(1).backgroundColor(Color.White).borderRadius(10).justifyContent(FlexAlign.Center).height(90)
                  Blank().width(10).height(0)
                  Row(){
                    Text("智慧屏").fontSize(16)
                    Blank().width(15).height(0)
                    Image($r('app.media.ic_device_smartscreen_filled')).width(50).aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                  }.layoutWeight(1).backgroundColor(Color.White).borderRadius(10).justifyContent(FlexAlign.Center).height(90)
                }.width("100%")
                Blank().width(0).height(10)
                Row(){
                  Column(){
                    Image($r('app.media.ic_device_sound_x_filled')).width(40).aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Blank().width(15).height(0)
                    Text("音箱").fontSize(16)
                  }.layoutWeight(1).backgroundColor(Color.White).borderRadius(10).height(90).justifyContent(FlexAlign.Center)
                  Blank().width(10).height(0)
                  Column(){
                    Image($r('app.media.ic_device_vr_glass_filled')).width(40).aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Blank().width(15).height(0)
                    Text("VR眼镜").fontSize(16)
                  }.layoutWeight(1).backgroundColor(Color.White).borderRadius(10).height(90).justifyContent(FlexAlign.Center)
                  Blank().width(10).height(0)
                  Column(){
                    Image($r('app.media.ic_device_watch_filled')).width(40).aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Blank().width(15).height(0)
                    Text("手表").fontSize(16)
                  }.layoutWeight(1).backgroundColor(Color.White).borderRadius(10).height(90).justifyContent(FlexAlign.Center)
                  Blank().width(10).height(0)
                  Column(){
                    Image($r('app.media.ic_public_devices_phone_filled')).width(40).aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Blank().width(15).height(0)
                    Text("手机").fontSize(16)
                  }.layoutWeight(1).backgroundColor(Color.White).borderRadius(10).height(90).justifyContent(FlexAlign.Center)
                }.height(90)

              }.height(ITEM_CARDS_AREA_HEIGHT).width("100%").justifyContent(FlexAlign.Center).opacity(this.itemCardsAreaOpacity)
            }
            Scroll(this.inSideScrollController){
              Column(){
                Row({ space: 10 }) {
                  Column({ space: 10 }) {
                    Image($r('app.media.ic_gallery_puzzle')).width(40)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Text("拼图")
                      .fontSize(16)
                      .fontColor(Color.Black)
                      .textAlign(TextAlign.Center)
                  }
                  .scale({x:this.classifyAreaOpacity,y:this.classifyAreaOpacity})
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Center)

                  Column({ space: 10 }) {
                    Image($r('app.media.ic_public_car')).width(40)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Text("汽车")
                      .fontSize(16)
                      .fontColor(Color.Black)
                      .textAlign(TextAlign.Center)
                  }
                  .scale({x:this.classifyAreaOpacity,y:this.classifyAreaOpacity})
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Center)

                  Column({ space: 10 }) {
                    Image($r('app.media.ic_device_watch_filled')).width(40)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Text("钱包")
                      .fontSize(16)
                      .fontColor(Color.Black)
                      .textAlign(TextAlign.Center)
                  }
                  .scale({x:this.classifyAreaOpacity,y:this.classifyAreaOpacity})
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Center)

                  Column({ space: 10 }) {
                    Image($r('app.media.ic_public_cards')).width(40)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Text("收藏")
                      .fontSize(16)
                      .fontColor(Color.Black)
                      .textAlign(TextAlign.Center)
                  }
                  .scale({x:this.classifyAreaOpacity,y:this.classifyAreaOpacity})
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Center)

                  Column({ space: 10 }) {
                    Image($r('app.media.ic_contacts_birthday')).width(40)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Text("生日")
                      .fontSize(16)
                      .fontColor(Color.Black)
                      .textAlign(TextAlign.Center)
                  }
                  .scale({x:this.classifyAreaOpacity,y:this.classifyAreaOpacity})
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Center)
                }.height(100).width("100%").opacity(this.classifyAreaOpacity)
                ForEach(this.fakeProduct,(item:string,index:number)=>{
                  ListItem(){
                    Row(){
                      Text(item)
                    }.width("100%").height(50).justifyContent(FlexAlign.Center).backgroundColor(Color.White).borderRadius(12)
                  }
                })
              }.margin({top:ITEM_CARDS_AREA_HEIGHT})

            }.nestedScroll({
              scrollForward: NestedScrollMode.PARENT_FIRST,
              scrollBackward: NestedScrollMode.SELF_FIRST
            }).onScrollFrameBegin((offset:number)=>{
              let yOffset = this.inSideScrollController.currentOffset().yOffset
              console.error(`inSideScroll ${yOffset}`)

             let maxDiff = (ITEM_CARDS_AREA_HEIGHT - HORIZONTAL_LIST_HEIGHT)
             let diff =maxDiff - yOffset
              if(diff>= 0){
                this.itemCardsAreaOpacity = diff/maxDiff
                this.classifyAreaOpacity = diff/maxDiff
                this.showHorizontalList =false
              }else{
                this.horizontalListOpacity = -diff/maxDiff
                this.showHorizontalList = true


                let calcSpace:number = MAX_HORIZONTAL_LIST_SPACE + diff
                if(calcSpace > MIN_HORIZONTAL_LIST_SPACE){
                  this.horizontalListSpace = calcSpace
                }else{
                  this.horizontalListSpace = MIN_HORIZONTAL_LIST_SPACE
                }

              }
              return {offsetRemain:offset}
            })
          }
        }.margin({top:50}).height("100%").justifyContent(FlexAlign.Start)
      }.padding({left:15,right:15}).height("100%").width("100%")
      .onScrollFrameBegin((offset:number,state:ScrollState)=>{
        let yOffset = this.outSideScrollController.currentOffset().yOffset
        this.searchAreaHeight = SEARCH_AREA_HEIGHT - yOffset * 0.6
        return {offsetRemain:offset}
      })
    }.backgroundColor("#f1f1f1")
    .height('100%')
    .width('100%')
  }
}