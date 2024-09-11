import { FourText } from './FourText'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { promptAction } from '@kit.ArkUI'

@Entry
@Component
struct InputVerificationByText{
  build() {
    Column(){

      Text("四个 Text,调起键盘，记录输入").fontSize(20).fontColor(Color.Black)
      FourText({onFinishInput:(value:string)=>{
        hilog.error(0x01,"InputVerificationCode",`FourTextInput finish ${value}`)
        promptAction.showToast({message:"输入的验证码是--> " + value})
      }}).margin(10)
    }
  }
}