import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';

@HMRouter({pageUrl:'protocol_dialog', dialog: true})
@Component
export struct  ProtocolDialog{

  build() {
    Column(){
      Column(){
        Text('这是弹窗内容')
        Button('查看具体内容').margin(10)
          .onClick((_)=>{
            HMRouterMgr.push({pageUrl:'protocol_detail'})
          })
      }.backgroundColor(Color.White).borderRadius(20)
    }.width('100%').height('100%').backgroundColor("#f7e5e5e5")
    .alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center).onClick((_)=>{
      HMRouterMgr.pop()
    })

  }
}