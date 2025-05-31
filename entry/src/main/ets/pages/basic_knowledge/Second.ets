import router from '@ohos.router'
import { ActionBar } from '../../comm/ActionBar';
import { HelloComponent } from '../../component/HelloComponent'
import { getMainRouterInfo, MainRouterParams } from './RouterParams'
import { hilog } from '@kit.PerformanceAnalysisKit'

@Entry
@Component
struct Second {
  @State message: string = 'hi second'
  @State routerParams?: MainRouterParams = undefined

  aboutToAppear(): void {
    this.routerParams = router.getParams() as MainRouterParams
    let params = router.getParams()

    let tmp: MainRouterParams = new MainRouterParams()
    tmp.name = "Second"
    hilog.error(0x01, "Second", "aboutToAppear--> " + JSON.stringify(this.routerParams))
    hilog.error(0x01, "Second", "aboutToAppear--> " + JSON.stringify(tmp))
  }

  build() {
    Column() {



      // ActionBar({ title: '第二个页面' })
      ActionBar()
      Text(this.message)
        .fontColor('#1b91e0')
        .fontWeight(FontWeight.Lighter)
      Text(getMainRouterInfo(this.routerParams)).width(50).height(50).backgroundColor(Color.Pink)
      Button() {
        Text('back')
          .fontWeight(FontWeight.Medium)
          .fontColor('#666666')

      }
      .type(ButtonType.Normal)
      .backgroundColor('#0D9FFB')
      .margin({
        top: 20
      })
      .width('40%')
      .height('5%')
      .onClick(() => {
        router.back()
      })

      HelloComponent()


        .width('100%')
    }.height('100%').width('100%')

  }
}

// @Component
// struct HelloComponent{
//   @State message:string = "hello"
//   @State count:number = 0;
//   build(){
//
//     Row(){
//       Text( `${this.message}   ${this.count}`)
//         .onClick(()=>{
//           this.count ++;
//           this.message = `you had click for ${this.count} times`
//         })
//         .fontColor('#999999')
//         .fontSize(14)
//         .fontWeight(FontWeight.Regular)
//     }
//
//   }
// }
