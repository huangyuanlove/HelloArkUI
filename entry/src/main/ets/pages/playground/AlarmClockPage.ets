import { ClockView } from './ClockView'
@Entry
@Component
struct AlarmClockPage{
  build(){
    Column(){
      ClockView().width("100%").height("50%")
    }

  }
}