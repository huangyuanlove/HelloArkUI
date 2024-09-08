import { CountDownTimer } from './TimerCountDown'
import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct TimerPage{
  aboutToAppear(): void {

  }

  async  onCountDownTimerClick(event:ClickEvent): Promise<boolean>{

    const session = rcp.createSession();
      let result= await session.get("https://api.123.com/").catch((error:BusinessError)=>{
        hilog.error(0x01,"onCountDownTimerClick",`error-->${error}`)
      })
    if(result){
      hilog.error(0x01,"onCountDownTimerClick",`result-->${result}`)
      return true
    }else{
      return false
    }

  }

  build() {
    Column(){
      CountDownTimer({timeFormat:"-%s秒-后重新获取",finishedText:"重新获取",countDownTimeMS:10*1000,clickEvent:this.onCountDownTimerClick,fontsize:18})
    }

  }
}