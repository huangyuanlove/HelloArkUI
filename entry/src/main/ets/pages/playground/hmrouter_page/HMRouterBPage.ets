import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";


@HMRouter({ pageUrl: 'pages/playground/hmrouter_page/HMRouterBPage', })
@Entry
@Component
export struct  HMRouterBPage{

  @State params: Record<string, Object> = HMRouterMgr.getCurrentParam() as Record<string, Object>

  build() {
      Column(){
        if(this.params){
          Text('接收到的参数')
          Text(JSON.stringify(this.params))
        }

        Button('携带参数返回上级页面').onClick((_)=>{
          HMRouterMgr.pop({param:{
            resultKey1:'resultValue1',
            resultKey2:456,
            resultKey3:true
          }})
        })
      }.width('100%').height('100%')
  }
}