import { ClockView } from './ClockView'
@Entry
@Component
struct AlarmClockPage{

  @State second:number = 0
  @State minute:number = 0
  @State hour:number = 0

  private timerInterval:number = -1

  aboutToAppear(){
    this.getCurrentTime()
    if(this.timerInterval < 0){
      this.timerInterval =setInterval(function(){
        this.getCurrentTime()
      }.bind(this), 500)
    }

  }
  aboutToDisappear(){
    if(this.timerInterval > 0){
      clearInterval(this.timerInterval)
    }
  }

  getCurrentTime(){
    let date:Date = new Date()
    this.hour =date.getHours()
    this.minute = date.getMinutes()
    this.second = date.getSeconds()

  }


  build(){
    Column(){
      ClockView().width("100%").height("50%")
      Text(`${this.hour}:${this.minute}:${this.second}`).fontSize(36)
    }

  }
}