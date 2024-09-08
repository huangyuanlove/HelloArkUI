import { util } from '@kit.ArkTS'


class MyTextTimerModifier implements ContentModifier<TextTimerConfiguration> {


  applyContent(): WrappedBuilder<[TextTimerConfiguration]> {
    return wrapBuilder(buildTextTimer)
  }
}

@Builder
function buildTextTimer(config: TextTimerConfiguration) {

  Text(clickAble(config)?timeCountDownFinish:  util.format(timeFormat, (Math.max(config.count / 1000 - config.elapsedTime / 100, 0)).toFixed(0)))
    .fontColor(clickAble(config)?clickableFontColor:notClickableFontColor)
    .fontSize(fontSize)
}

function clickAble(config: TextTimerConfiguration):boolean{
  return config.elapsedTime *10 >= config.count
}

let timeFormat:string = ''
let timeCountDownFinish:string =''
let clickableFontColor:ResourceColor=Color.Green
let notClickableFontColor:ResourceColor=Color.Gray
let fontSize : number | string | Resource = 14



function setTimeFormat(format:string){
  timeFormat = format
}
function setTimeCountDownFinish(str:string){
  timeCountDownFinish = str
}
function setClickableFontColor(color:ResourceColor){
  clickableFontColor = color
}
function setNotClickableFontColor(color:ResourceColor){
  notClickableFontColor = color
}
function setFontSize(size: number | string | Resource){
  fontSize = size
}




@Component
struct CountDownTimer {
  timeFormat: string = '%s'
  finishedText:string=''
  startOnAppear:boolean=true
  countDownTimeMS: number = 60000
  clickableFontColor:ResourceColor=Color.Green
  notClickableFontColor:ResourceColor=Color.Gray
  fontsize:number | string | Resource =12
  @State myTimerModifier: MyTextTimerModifier = new MyTextTimerModifier()
  countDownTextTimerController: TextTimerController = new TextTimerController()

  private clickable:boolean=false

  clickEvent?: (event: ClickEvent) => Promise<boolean>
  fancyStyle?:()=>void

  aboutToAppear(): void {
    setTimeFormat(this.timeFormat)
    setTimeCountDownFinish(this.finishedText)
    setClickableFontColor(this.clickableFontColor)
    setNotClickableFontColor(this.notClickableFontColor)
    setFontSize(this.fontsize)
  }


  build() {
    TextTimer({ isCountDown: true, count: this.countDownTimeMS, controller: this.countDownTextTimerController })
      .contentModifier(this.myTimerModifier)
      .onClick(async (event)=>{
        if(this.clickable){
          if(this.clickEvent){
            if(await this.clickEvent(event)){
              this.countDownTextTimerController.reset()
              this.countDownTextTimerController.start()
            }
          }

        }
      })
      .onTimer((utc: number, elapsedTime: number) => {


        if(elapsedTime*10 >= this.countDownTimeMS){
          this.countDownTextTimerController.pause()
          this.clickable = true
        }else{
          this.clickable = false
        }
      }).onAppear(() => {
        if(this.startOnAppear){
          this.countDownTextTimerController.start()
        }else{
          this.clickable = true
        }
    })

  }
}

export { CountDownTimer }