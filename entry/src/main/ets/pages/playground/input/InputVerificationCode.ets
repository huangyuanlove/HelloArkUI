import { hilog } from '@kit.PerformanceAnalysisKit'
import { FourTextInput } from './FourTextInput'

@Entry
@Component
struct InputVerificationCode{
  build() {
      Column(){
        FourTextInput({onFinishInput:(value:string)=>{
          hilog.error(0x01,"InputVerificationCode",`FourTextInput finish ${value}`)
        }}).margin(10)
      }
  }
}

