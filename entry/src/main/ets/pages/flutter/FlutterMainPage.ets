import { HMPopInfo, HMRouter } from '@hadss/hmrouter';
import { router } from '@kit.ArkUI';
import { ActionBar } from '../../comm/ActionBar';
import { FlutterPath, MyFlutterRouter } from './MyFlutterRouter';

@HMRouter({ pageUrl: 'pages/flutter/FlutterMainPage' })
@Component
export struct FlutterMainPage {
  @State message: string = '';
  @State popResult:Map<string,Object> | undefined = undefined
  build() {
    Column() {
      ActionBar({title:"flutter测试页面"})
      Button("HMRouter flutter").onClick((_) => {
        MyFlutterRouter.push(FlutterPath.LOGIN, { "name": "harmonyos", "age": 3 }, {
          onResult: (popInfo: HMPopInfo) => {
            console.error(`FlutterMainPage.push result ${popInfo.result}`)
            this.popResult = popInfo.result as Map<string,Object>
            if(this.popResult){
              this.message = ""
              this.popResult.forEach((value,key)=>{
                this.message += `${key} : ${value} \n`
              })
            }
          },
          onArrival: () => {
            console.error(`FlutterMainPage.push onArrival `)
          },
          onLost: () => {
            console.error(`FlutterMainPage.push onLost `)
          }
        })
      })

      Text("页面返回携带的参数")
      Text(this.message)

      Button("router and flutter entry")

        .onClick((_) => {
        router.pushUrl({ url: "pages/flutter/FlutterEntryWithRouterPage" })
      }).margin({top:20})
    }
    .height('100%')
    .width('100%')
  }
}