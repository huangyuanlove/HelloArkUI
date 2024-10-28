import ActionBar from '../../../../comm/ActionBar';
import { router } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct UseASPage {
  @State message: string = 'Hello World';

  @State user?:User = undefined

  aboutToAppear(): void {
     this.user=   router.getParams() as User
      hilog.error(0x01,'UseASPage','获取到的参数-->' + JSON.stringify(this.user))

  }



  build() {
    Column(){
      ActionBar({title:"UseAs"})

      Text(JSON.stringify(this.user))

      Button('调用对象方法').onClick((_)=>{
        if(this.user){
          hilog.error(0x01,'UseASPage','调用对象方法-->' +this.user.getInfo())
        }
      })

    }
    .height('100%')
    .width('100%')
  }
}

export class User{
  name:string = ''
  getInfo():string{
    return JSON.stringify(this)
  }
}