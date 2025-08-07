import { emitter } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct EventOnePage {
  @State message: string = 'Hello World';


  emitterCallback: Callback<emitter.EventData> = (eventData: emitter.EventData) => {
    console.error(`EventOnePage emitter 收到 EventHubEventOne: ${JSON.stringify(eventData)}`);
  }
  eventHubCallback(argOne: Context, argTwo: Context): void {
    console.error("EventOnePage emitter 收到 EventHubEventOne")
  }

  aboutToAppear(): void {
    emitter.on("EmitterEventOne", this.emitterCallback)
    this.getUIContext().getHostContext()?.eventHub.on("EventHubEventOne", this.eventHubCallback)

  }

  aboutToDisappear(): void {
    emitter.off("EmitterEventOne",this.emitterCallback)
    this.getUIContext().getHostContext()?.eventHub.off("EventHubEventOne",this.eventHubCallback)
  }

  build() {
    Column() {
      Text("发送事件")
        .id('EventOnePageHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)

        .onClick(() => {
          emitter.emit("EmitterEventOne")
          this.getUIContext().getHostContext()?.eventHub.emit("EventHubEventOne")
        })
      Text("EventTwoPage")
        .id('EventMainPageHelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          router.push({url:"pages/playground/event/EventTwoPage"})
        })
    }
    .height('100%')
    .width('100%')
  }
}