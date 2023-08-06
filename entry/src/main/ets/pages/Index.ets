import router from '@ohos.router'
@Extend(Button) function indexButtonStyle(path:string){
  .type(ButtonType.Capsule)
  .margin({
    top: 20
  })
  .backgroundColor('#39d167')
  .onClick(()=>{
    router.pushUrl({url:path})
  })
}


@Component
export struct IndexItem{

  path:string ;
  label:string;

  build(){
    Button() {
      Text(this.label)
        .fontSize(30)
        .padding(10)
    }.indexButtonStyle(this.path)
  }
}

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  build() {
    Scroll(this.scroller){
      Column() {
        IndexItem({label:'基础',path:'pages/Base'})
        IndexItem({label:'生命周期',path:'pages/LifeCirclePage'})
        IndexItem({label:'参数传递',path:'pages/AboutParams'})
        IndexItem({label:'参数传递',path:'pages/AboutParams'})
        IndexItem({label:'@Styles装饰器',path:'pages/AboutStyleAnno'})
        IndexItem({label:'@Extend装饰器',path:'pages/AboutExtendAnno'})
        IndexItem({label:'@stateStyles',path:'pages/AboutStateStyles'})
        IndexItem({label:'状态管理',path:'pages/AboutStateManagement'})
      }
    }.height('100%').width('100%').backgroundColor(Color.Grey)
    .scrollable(ScrollDirection.Vertical)  // 滚动方向纵向
    .scrollBar(BarState.On)  // 滚动条常驻显示
    .scrollBarColor(Color.Gray)  // 滚动条颜色
    .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.None)
    }

}