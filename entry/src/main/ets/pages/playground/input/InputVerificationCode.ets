import { hilog } from '@kit.PerformanceAnalysisKit'
import { FourTextInput } from './FourTextInput'
import { promptAction } from '@kit.ArkUI'
import { FourText } from './FourText'
import { ActionBar } from '../../../comm/ActionBar'

@Entry
@Component
struct InputVerificationCode{
  private  letterSpacing : number =50

  aboutToAppear(): void {

  }

  build() {
      Column(){
        ActionBar({title:"TextInput 实现"})
        Text("四个 TextInput 拼接，代码控制焦点").fontSize(20).fontColor(Color.Black)
        FourTextInput({onFinishInput:(value:string)=>{
          hilog.error(0x01,"InputVerificationCode",`FourTextInput finish ${value}`)
          promptAction.showToast({message:"输入的验证码是--> " + value})
        }}).margin(10)

      }
  }
}

