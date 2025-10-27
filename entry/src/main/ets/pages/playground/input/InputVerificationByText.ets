import { FourText } from './FourText'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { promptAction } from '@kit.ArkUI'
import { ActionBar } from '../../../comm/ActionBar'

@Entry
@Component
struct InputVerificationByText{
  build() {
    Column(){
      ActionBar({title:"Text 实现"})
      Text("四个 Text,调起键盘，记录输入").fontSize(20).fontColor(Color.Black)
      FourText({onFinishInput:(value:string)=>{
        hilog.error(0x01,"InputVerificationCode",`FourTextInput finish ${value}`)
        promptAction.showToast({message:"输入的验证码是--> " + value})
      }}).margin(10)
    }
  }
}